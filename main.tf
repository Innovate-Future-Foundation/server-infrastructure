provider "aws" {
  region = var.aws_region
}

module "ecs_cluster" {
  source = "./modules/ecs_cluster"
  cluster_name = var.cluster_name
}

module "ecs_task_definition" {
  source = "./modules/ecs_task_definition"
  task_family = var.task_family
  ecr_repository_url = var.ecr_repository_url
  db_migration_image = var.db_migration_image
  backend_api_image = var.backend_api_image
  postgres_image = var.postgres_image
}

module "ecs_service" {
  source = "./modules/ecs_service"
  cluster_id = module.ecs_cluster.cluster_id
  task_definition_arn = module.ecs_task_definition.task_definition_arn
  service_name = var.service_name
  desired_count = var.desired_count
}
