locals {
  # Network Settings
  vpc = {
    vpc_name = "inff-uat-main"
    cidr     = "10.1.0.0/16"
    public_subnets = {
      api-subnet = {
        cidr = "10.1.0.0/20"
        az   = "ap-southeast-2a"
      },
      tool-subnet = {
        cidr = "10.1.16.0/20"
        az   = "ap-southeast-2a"
      }
    }
    private_subnet = {
      preserved-subnet = {
        cidr = "10.1.32.0/20"
        az   = "ap-southeast-2a"
      },
    }
  }

  # ECS Cluster and Task Definition Settings
  main_ecs_def = {
    cluster_name = "inff-backend"
    families = {
      backend = {
        role = "inff-backend-ecs-role"
        name = "inff-api"
        cpu  = 256
        mem  = 512
        # Containers Definition
        containers = templatefile("backend-task-def-template.json", {
          backend_base_repo    = var.central_ecr_base_repo_uri
          backend_publish_repo = var.central_ecr_publish_repo_uri
          # Container Envs
          db_user    = "db_admin"
          db_pass    = "123321aab@"
          db_name    = "InnovateFuture"
          jwt_secret = "5-3218)7v*qX3CN2"
          dep_env    = "Development"
          # Logging Settings
          logs_region = var.region
          logs_group  = module.cloudwatch.log_group_names["ecs_default"]
        })
      }
    }
  }

  # ECS Service
  main_ecs_srv = {
    name    = "uat-api-srv"
    cluster = module.main_ecs_def.cluster_id
    family  = module.main_ecs_def.task_family_arns["backend"]
    network = {
      subnets = [
        module.network.public_subnet_ids["api-subnet"]
      ]
      security_groups = [
        module.network.security_group_ids["backend"]
      ]
      assign_pub_ip = true
    }

    srv_registry = {
      registry_arn   = module.cloud_map.service_arns["backend"]
      container_name = "api"
      container_port = 5091
    }
  }

  ecs_logs_group      = "inff/ecs/default_log_group"
  task_execution_role = "inff-backend-ecs-role"
}

module "network" {
  source          = "../modules/network"
  vpc_name        = "${local.vpc.vpc_name}-vpc"
  vpc_cidr        = local.vpc.cidr
  public_subnets  = local.vpc.public_subnets
  private_subnets = local.vpc.private_subnet

  security_groups = {
    backend = {
      name        = "backend-sg"
      description = "Security group for dotnet api"
      ingress_rules = [{
        from_port   = 5091
        to_port     = 5091
        protocol    = "tcp"
        cidr_blocks = [local.vpc.public_subnets.api-subnet.cidr]
        }, {
        from_port = 5432
        to_port   = 5432
        protocol  = "tcp"
        cidr_blocks = [
          local.vpc.public_subnets.api-subnet.cidr,
          local.vpc.public_subnets.tool-subnet.cidr
        ]
      }]
    },
    tool = {
      name        = "web-tool-sg"
      description = "Security group for pgadmin web"
      ingress_rules = [{
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = [var.anywhere_cidr]
      }]
    }
  }
}

module "main_ecs_def" {
  source       = "../modules/ecs-def"
  cluster_name = local.main_ecs_def.cluster_name
  families     = local.main_ecs_def.families
}

module "main_ecs_srv" {
  source       = "../modules/ecs-srv"
  name         = local.main_ecs_srv.name
  cluster      = module.main_ecs_def.cluster_id
  family       = local.main_ecs_srv.family
  network      = local.main_ecs_srv.network
  srv_registry = local.main_ecs_srv.srv_registry
}

module "cloudwatch" {
  source = "../modules/cloudwatch_logs"
  log_groups = {
    ecs_default = {
      name      = var.ecs_logs_group
      retention = 14
    }
  }
}

module "cloud_map" {
  source      = "../modules/cloud-map"
  namespace   = "inff-uat-ns"
  description = "Namespace for InFF UAT Enviroment"
  vpc_id      = module.network.vpc_id

  services = {
    backend = {
      name = "api"
      dns_records = [{
        ttl  = 10
        type = "SRV"
        }, {
        ttl  = 10
        type = "A"
      }]
    }
  }
}

module "api_gateway" {
  source      = "../modules/api-gateway"
  name        = "inff-uat-backend"
  description = "HTTP API Gateway for Inff UAT"

  vpc_links = {
    backend = {
      name = "inff-uat-backend-agw"
      subnets = [
        module.network.public_subnet_ids["api-subnet"]
      ]
      security_groups = [
        module.network.security_group_ids["backend"]
      ]
    }
  }

  cloud_map_integrations = {
    backend = {
      service  = module.cloud_map.service_arns["backend"]
      vpc_link = "backend"
    }
  }

  routes = {
    api = {
      method      = "ANY"
      path        = "/api/{proxy+}"
      integration = "backend"
    }
    swagger = {
      method      = "ANY"
      path        = "/swagger/{proxy+}"
      integration = "backend"
    }
  }
}

output "api_gateway_endpoint" {
  description = "API Gateway endpoint URL"
  value       = module.api_gateway.api_endpoint
}
