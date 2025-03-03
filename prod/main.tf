locals {
  # Central ECR URI
  base_repo    = "inff/backend-base"
  base_uri     = "${var.prod_account_id}.dkr.ecr.${var.ecr_region}.amazonaws.com/${local.base_repo}"
  publish_repo = "inff/backend-publish"
  publish_uri  = "${var.prod_account_id}.dkr.ecr.${var.ecr_region}.amazonaws.com/${local.publish_repo}"

  # Network Settings
  vpc = {
    vpc_name = "inff-prod-main"
    cidr     = "10.1.0.0/16"
    public_subnets = {
      api-a-subnet = {
        cidr = "10.1.0.0/20"
        az   = "us-west-2a"
      }
      api-b-subnet = {
        cidr = "10.1.16.0/20"
        az   = "us-west-2b"
      },
      tool-subnet = {
        cidr = "10.1.32.0/20"
        az   = "us-west-2a"
      },
    }
    private_subnet = {
      preserved-subnet = {
        cidr = "10.1.48.0/20"
        az   = "us-west-2a"
      },
    }
  }

  # ECS Cluster and Task Definition Settings
  main_ecs_def = {
    cluster_name = "inff-prod-backend"
    families = {
      backend = {
        role = "inff-backend-ecs-role"
        name = "inff-prod-api"
        cpu  = 1024
        mem  = 2048
        # Containers Definition
        containers = templatefile("backend-task-def-template.json", {
          backend_base_repo    = local.base_uri
          backend_publish_repo = local.publish_uri
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
    name    = "api-srv"
    cluster = module.main_ecs_def.cluster_id
    family  = module.main_ecs_def.task_family_arns["backend"]
    network = {
      subnets = [
        module.network.public_subnet_ids["api-a-subnet"],
        module.network.public_subnet_ids["api-b-subnet"]
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

  ecs_logs_group          = "inff/ecs/default_log_group"
  task_execution_role     = "inff-backend-ecs-role"
  central_ecr_repo_policy = data.aws_iam_policy_document.central_ecr_repo_policy.json
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
        from_port = 5091
        to_port   = 5091
        protocol  = "tcp"
        cidr_blocks = [
          local.vpc.public_subnets.api-a-subnet.cidr,
          local.vpc.public_subnets.api-b-subnet.cidr,
        ] }, {
        from_port = 5432
        to_port   = 5432
        protocol  = "tcp"
        cidr_blocks = [
          local.vpc.public_subnets.api-a-subnet.cidr,
          local.vpc.public_subnets.api-b-subnet.cidr,
          local.vpc.public_subnets.tool-subnet.cidr
        ]
      }]
    },
  }
}

module "cloud_map" {
  source      = "../modules/cloud-map"
  namespace   = "inff-prod-ns"
  description = "Namespace for InFF Prod Enviroment"
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

module "cloudwatch" {
  source = "../modules/cloudwatch_logs"
  log_groups = {
    ecs_default = {
      name      = local.ecs_logs_group
      retention = 14
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

module "ecr" {
  providers = { aws = aws.central_ecr }
  source    = "../modules/ecr"

  repositories = {
    backend-publish = {
      name        = "inff/backend-publish"
      description = "API server container images"
      policy      = local.central_ecr_repo_policy
    }
    backend-base = {
      name        = "inff/backend-base"
      description = "Base server container images"
      policy      = local.central_ecr_repo_policy
    }
  }

  # Must provision after task role (including that of other envs)
  depends_on = [module.main_ecs_def]
}

module "api_gateway" {
  source      = "../modules/api-gateway"
  name        = "inff-prod-backend"
  description = "HTTP API Gateway for Inff Production"

  vpc_links = {
    backend = {
      name = "inff-prod-backend-agw"
      subnets = [
        module.network.public_subnet_ids["api-a-subnet"],
        module.network.public_subnet_ids["api-b-subnet"]
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
  }
}
