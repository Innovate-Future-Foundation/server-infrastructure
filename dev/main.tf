provider "aws" {
  region = var.region
  default_tags {
    tags = local.general_tags
  }
}

locals {
  general_tags = {
    ManagedBy = "Terraform"
    Usage     = "ServerInfrastructure"
    Env       = "Development"
  }
}

module "network" {
  source   = "../modules/network"
  vpc_name = "${var.vpc_name}-vpc"
  vpc_cidr = var.vpc_cidr
  public_subnets = {
    "api-subnet" = {
      cidr = var.api_subnet_cidr
      az   = var.subnet_az
    },
    "tool-subnet" = {
      cidr = var.tool_subnet_cidr
      az   = var.subnet_az
    }
  }

  private_subnets = {
    "preserved-subnet" = {
      cidr = var.private_subnet_cidr
      az   = var.subnet_az
    }
  }

  security_groups = {
    backend = {
      name        = "backend-sg"
      description = "Security group for dotnet api"
      ingress_rules = [{
        from_port   = 5091
        to_port     = 5091
        protocol    = "tcp"
        cidr_blocks = [var.api_subnet_cidr]
        }, {
        from_port   = 5432
        to_port     = 5432
        protocol    = "tcp"
        cidr_blocks = [var.api_subnet_cidr, var.tool_subnet_cidr]
      }]
    },
    tool = {
      name        = "web-tool-sg"
      description = "Security group for pgadmin web"
      ingress_rules = [{
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = [var.api_subnet_cidr, var.tool_subnet_cidr]
      }]
    }
  }
}

module "ecs" {
  source = "../modules/ecs"

  cluster_name        = "${var.ecs_cluster_name}-cluster"
  family              = "${var.ecs_family_name}-definition"
  cpu                 = 256
  memory              = 512
  task_execution_role = "inff-backend-ecs-role"

  # subnets         = [for k, v in module.network.public_subnet_ids : v]
  subnets          = [module.network.public_subnet_ids["api-subnet"]]
  security_groups  = [module.network.security_group_ids["backend"]]
  assign_public_ip = true

  # Containers
  container_definitions = templatefile("backend-task-def-template.json", {
    # Private ECR url
    # backend_base_repo    = module.ecr.repository_urls["backend-base"]
    # backend_publish_repo = module.ecr.repository_urls["backend-publish"]
    backend_base_repo    = "376129846478.dkr.ecr.ap-southeast-2.amazonaws.com/inff/base-server"
    backend_publish_repo = "376129846478.dkr.ecr.ap-southeast-2.amazonaws.com/inff/api-server"
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

  service_name = "${var.ecs_service_name}-srv"
  registry_arn = module.cloud_map.service_arns["backend"]
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
  namespace   = "inff-dev-ns"
  description = "Namespace for InFF Dev Enviroment"
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
  name        = "inff-dev-backend"
  description = "HTTP API Gateway for Inff Dev"

  vpc_links = {
    backend = {
      name = "inff-dev-backend-agw"
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
    health = {
      method      = "GET"
      path        = "/health"
      integration = "backend"
    }
  }
}

output "api_gateway_endpoint" {
  description = "API Gateway endpoint URL"
  value       = module.api_gateway.api_endpoint
}
