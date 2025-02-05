provider "aws" {
  region = var.region
}

# Use the default VPC and its subnets
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
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

module "security_group" {
  source   = "./modules/security_group"
  sg_name  = "ecs-multi-container-sg"
  vpc_id   = data.aws_vpc.default.id
  vpc_cidr = data.aws_vpc.default.cidr_block
}

module "ecs_multi" {
  source = "./modules/ecs_multi_container"

  family             = "multi-container-task"
  cpu                = var.task_cpu
  memory             = var.task_memory
  execution_role_arn = module.iam.role_arn
  cluster_name       = var.cluster_name

  subnets         = data.aws_subnets.default.ids
  security_groups = [module.security_group.sg_id]
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

  region = var.region
}

# output "ecs_cluster_name" {
#   description = "ECS cluster name"
#   value       = module.ecs_cluster.cluster_name
# }

# output "ecs_service_name" {
#   description = "ECS service name for multi-container task"
#   value       = module.ecs_multi.service_name
# }
