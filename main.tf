provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source               = "./modules/vpc"
  cidr_block           = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.3.0/24"]
  private_subnet_cidrs = ["10.0.2.0/24", "10.0.4.0/24"]
  availability_zones   = ["ap-southeast-2a", "ap-southeast-2b"]
  environment          = "dev"
}

module "ecs_cluster" {
  source       = "./modules/ecs_cluster"
  cluster_name = "inff-dev-cluster"
  environment  = "dev"
}

module "ecs_task_definition" {
  source             = "./modules/ecs_task_definition"
  family             = "inff-server-build"
  cpu                = "4096"
  memory             = "8192"
  execution_role_arn = "arn:aws:iam::842675993907:role/ecsTaskExecutionRole"
  environment        = "dev"

  container_definitions = [
    {
      name            = "postgres"
      image           = "postgres:17.2"
      cpu             = 512
      memory          = 512
      essential       = true
      command         = ["postgres"]
      portMappings    = [
        {
          name          = "postgres-port"
          containerPort = 5432
          hostPort      = 5432
          protocol      = "tcp"
        }
      ]
      environment     = [
        { name = "POSTGRES_USER", value = "admin" },
        { name = "POSTGRES_PASSWORD", value = "root" },
        { name = "POSTGRES_DB", value = "InnovateFuture" }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/inff-api-build"
          "awslogs-region"        = "ap-southeast-2"
          "awslogs-create-group"  = "true"
          "awslogs-stream-prefix" = "ecs"
        }
      }
      healthCheck = {
        command     = ["CMD-SHELL", "PGPASSWORD=root psql -U admin -h localhost -p 5432 -d InnovateFuture -c 'SELECT 1'"]
        interval    = 10
        timeout     = 3
        retries     = 1
        startPeriod = 30
      }
    },
    {
      name            = "pgadmin"
      image           = "dpage/pgadmin4"
      cpu             = 512
      memory          = 512
      essential       = false
      environment     = [
        { name = "PGADMIN_DEFAULT_EMAIL", value = "admin@admin.com" },
        { name = "PGADMIN_DEFAULT_PASSWORD", value = "root" }
      ]
      portMappings    = [
        {
          name          = "pgadmin-port"
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
      healthCheck = {
        command  = ["CMD-SHELL", "curl -f http://localhost/ || exit 1"]
        interval = 10
        timeout  = 5
        retries  = 3
      }
    },
    {
        name: "migration"
        image: "842675993907.dkr.ecr.ap-southeast-2.amazonaws.com/inff/api-build:34e60f9_1"
        cpu: 1024
        memory: 1024
        portMappings: []
        essential: false
        command: [
            "sh",
            "-c",
            "dotnet ef database update  --project InnovateFuture.Infrastructure/InnovateFuture.Infrastructure.csproj --startup-project InnovateFuture.Api/InnovateFuture.Api.csproj"
        ]
        environment: [
            {
                "name": "ASPNETCORE_ENVIRONMENT",
                "value": "Development"
            },
            {
                "name": "DBConnection",
                "value": "Host=127.0.0.1;Database=InnovateFuture;Username=admin;Password=root"
            },
            {
                "name": "JWTConfig__SecretKey",
                "value": "{\"SecrectKey\":\"SecrectKeyExample\",\"Issuer\":\"innovateFuture\",\"Audience\":\"innovateFuture\",\"ExpireSeconds\":7200}"
            }
        ]
        environmentFiles: []
        mountPoints: []
        volumesFrom: []
        dependsOn: [
            {
                "containerName": "postgres",
                "condition": "HEALTHY"
            }
        ]
        logConfiguration: {
            logDriver: "awslogs",
            options: {
                "awslogs-group": "/ecs/inff-api-build",
                "mode": "non-blocking",
                "awslogs-create-group": "true",
                "max-buffer-size": "5m",
                "awslogs-region": "ap-southeast-2",
                "awslogs-stream-prefix": "ecs"
            },
            secretOptions: []
        }
        systemControls: []
    },
    {
        name: "dotnet-app"
        image: "842675993907.dkr.ecr.ap-southeast-2.amazonaws.com/inff/api:34e60f9_1"
        cpu: 1024
        memory: 1024
        portMappings: [
            {
                "name": "web-port",
                "containerPort": 5091,
                "hostPort": 5091,
                "protocol": "tcp",
                "appProtocol": "http"
            }
        ]
        essential: false,
        entryPoint: [
            "dotnet",
            "InnovateFuture.Api.dll"
        ]
        environment: [
            {
                "name": "DBConnection",
                "value": "Host=localhost;Database=InnovateFuture;Username=admin;Password=root"
            },
            {
                "name": "ASPNETCORE_ENVIRONMENT",
                "value": "Development"
            },
            {
                "name": "JWTConfig__SecretKey",
                "value": "{\"SecrectKey\":\"SecrectKeyExample\",\"Issuer\":\"innovateFuture\",\"Audience\":\"innovateFuture\",\"ExpireSeconds\":7200}"
            },
            {
                "name": "ASPNETCORE_URLS",
                "value": "http://+:5091/"
            }
        ]
        environmentFiles: []
        mountPoints: []
        volumesFrom: []
        dependsOn: [
            {
                "containerName": "migration",
                "condition": "COMPLETE"
            }
        ]
        logConfiguration: {
            logDriver: "awslogs",
            options: {
                "awslogs-group": "/ecs/inff-api-build",
                "mode": "non-blocking",
                "awslogs-create-group": "true",
                "max-buffer-size": "5m",
                "awslogs-region": "ap-southeast-2",
                "awslogs-stream-prefix": "ecs"
            },
            secretOptions: []
        }
        healthCheck: {
            command: [
                "CMD-SHELL",
                "curl -f http://localhost:5091/swagger/index.html || exit 1"
            ],
            interval: 10,
            timeout: 5,
            retries: 3
        }
        systemControls: []
    }
  ]
}

module "alb_security_group" {
  source      = "./modules/security_group"
  name        = "alb-security-group"
  description = "Security group for the ALB"
  vpc_id      = module.vpc.vpc_id
  environment = "dev"

  ingress_rules = {
    "http" = {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    "dotnet" = {
      from_port   = 5091
      to_port     = 5091
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

module "application_load_balancer" {
  source              = "./modules/application_load_balancer"
  name                = "inff-alb"
  vpc_id              = module.vpc.vpc_id
  security_group_ids  = [module.alb_security_group.security_group_id]
  subnet_ids          = module.vpc.public_subnet_ids
  environment         = "dev"
}

module "ecs_service" {
  source              = "./modules/ecs_service"
  service_name        = "inff-ecs-service"
  cluster_name        = module.ecs_cluster.ecs_cluster_name
  cloudmap_service_arn = module.cloudmap.cloudmap_service_arn
  task_definition_arn = module.ecs_task_definition.task_definition_arn
  desired_count       = 1
  subnet_ids          = module.vpc.public_subnet_ids
  security_group_ids  = [module.alb_security_group.security_group_id]
  target_group_arn    = module.application_load_balancer.target_group_arn
  container_name      = "dotnet-app"
  container_port      = 5091
  environment         = "dev"
}

module "cloudmap" {
  source                  = "./modules/cloudmap"
  namespace_name          = "inff-ns"
  namespace_vpc_id        = module.vpc.vpc_id
  ecs_service_name            = "inff-server-service"
  dns_ttl                 = 60
}


