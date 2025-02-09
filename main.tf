provider "aws" {
  region = var.region
    default_tags {
    tags = local.general_tags
  }
}


resource "aws_cloudwatch_log_group" "ecs_migration" {
  name              = "/ecs/migration"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "ecs_api" {
  name              = "/ecs/api"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "ecs_pgadmin" {
  name              = "/ecs/pgadmin"
  retention_in_days = 14
}
module "ecs_cluster" {
  source       = "./modules/ecs_cluster"
  cluster_name = var.cluster_name
}

module "iam" {
  source    = "./modules/iam"
  role_name = var.role_name
}


module "ecs_multi" {
  source = "./modules/ecs_multi_container"

  family             = "multi-container-task"
  cpu                = var.task_cpu
  memory             = var.task_memory
  execution_role_arn = module.iam.role_arn
  cluster_name       = var.cluster_name

  # subnets         = [for k, v in module.network.public_subnet_ids : v]
  subnets         = [module.network.public_subnet_ids["api-subnet"]]
  security_groups = [module.network.security_group_ids["backend"]] #======
  assign_public_ip = true

  # ECR repository URL 
  ecr_repo_url = var.ecr_repo_url

  # Environment variables
  db_host    = var.db_host
  db_port    = var.db_port
  db_name    = var.db_name
  db_user    = var.db_user
  db_pass    = var.db_pass
  jwt_secret = var.jwt_secret
  dep_env    = var.dep_env
  pg_user    = var.pg_user
  pg_pass    = var.pg_pass
  api_port   = var.api_port

  region = var.region
}


locals {
  general_tags = {
    ManagedBy = "Terraform"
    Usage     = "ServerInfrastructure"
    Env       = "Development"
  }
  log_groups = {
    migration = "/ecs/migration"
    api       = "/ecs/api"
    pgadmin   = "/ecs/pgadmin"
  }
}

module "cloudwatch_logs" {
  source     = "./modules/cloudwatch_logs"
  log_groups = local.log_groups
}
module "network" {
  source   = "./modules/network"
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
