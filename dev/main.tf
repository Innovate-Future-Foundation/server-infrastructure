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
        from_port   = var.api_port
        to_port     = var.api_port
        protocol    = "tcp"
        cidr_blocks = [var.api_subnet_cidr]
        }, {
        from_port   = var.db_port
        to_port     = var.db_port
        protocol    = "tcp"
        cidr_blocks = [var.api_subnet_cidr, var.tool_subnet_cidr]
      }]
    },
    tool = {
      name        = "web-tool-sg"
      description = "Security group for pgadmin web"
      ingress_rules = [{
        from_port   = var.web_port
        to_port     = var.web_port
        protocol    = "tcp"
        cidr_blocks = [var.api_subnet_cidr, var.tool_subnet_cidr]
      }]
    }
  }
}

module "iam" {
  source    = "../modules/iam"
  role_name = var.role_name
}

module "ecs_multi" {
  source = "../modules/ecs"

  family             = "multi-container-task"
  cpu                = var.task_cpu
  memory             = var.task_memory
  execution_role_arn = module.iam.role_arn
  cluster_name       = var.cluster_name

  # subnets         = [for k, v in module.network.public_subnet_ids : v]
  subnets          = [module.network.public_subnet_ids["api-subnet"]]
  security_groups  = [module.network.security_group_ids["backend"]]
  assign_public_ip = true

  # Containers
  container_definitions = templatefile("backend-task-def-template.json", {
    # Database Credentials
    db_user = "db_admin"
    db_pass = "123321aab@"
    db_name = "InnovateFuture"
    # Private ECR url
    server_build_ecr = "376129846478.dkr.ecr.ap-southeast-2.amazonaws.com/inff/base-server"
    server_api_ecr   = "376129846478.dkr.ecr.ap-southeast-2.amazonaws.com/inff/api-server"
    # Api and Migration
    jwt_secret = "5-3218)7v*qX3CN2"
    dep_env    = "Development"
    # Logging Settings
    logs_region = var.region
    logs_group  = var.ecs_logs_group
  })

  service_name = "test-inff-dev-backend-srv"
  registry_arn = module.cloud_map.service_arns["backend"]
}

module "cloudwatch_logs" {
  source     = "../modules/cloudwatch_logs"
  log_groups = [var.ecs_logs_group]
}

module "cloud_map" {
  source      = "../modules/cloud-map"
  namespace   = "test-inff-dev-ns"
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
