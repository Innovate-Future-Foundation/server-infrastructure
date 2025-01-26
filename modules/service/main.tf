resource "aws_ecs_service" "postgres" {
  name            = "postgres-service"
  cluster         = var.cluster_id
  task_definition = var.postgres_task_arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnets
    security_groups = var.security_groups
  }
}

resource "aws_ecs_service" "migration" {
  name            = "migration-service"
  cluster         = var.cluster_id
  task_definition = var.migration_task_arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnets
    security_groups = var.security_groups
  }
  depends_on = [aws_ecs_service.postgres]
}

resource "aws_ecs_service" "api" {
  name            = "api-service"
  cluster         = var.cluster_id
  task_definition = var.api_task_arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnets
    security_groups = var.security_groups
  }
  depends_on = [aws_ecs_service.migration]
}
