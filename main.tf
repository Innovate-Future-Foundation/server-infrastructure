data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}


module "ecs_cluster" {
  source       = "./modules/cluster"
  cluster_name = "my-ecs-cluster"
}

module "task_definitions" {
  source          = "./modules/task_definition"
  db_user         = "admin"
  db_password     = "password123"
  db_name         = "my_database"
  db_host         = "postgres-service"
  migration_image = "123456789012.dkr.ecr.region.amazonaws.com/migration:latest"
  api_image       = "123456789012.dkr.ecr.region.amazonaws.com/api:latest"
}

module "ecs_service" {
  source             = "./modules/service"
  cluster_id         = module.ecs_cluster.cluster_id
  subnets            = data.aws_subnets.default.ids            
  security_groups    = ["sg-05583d58b1a6abe63"]    
  postgres_task_arn  = module.ecs_task_definitions.postgres_task_arn
  migration_task_arn = module.ecs_task_definitions.migration_task_arn
  api_task_arn       = module.ecs_task_definitions.api_task_arn
}
