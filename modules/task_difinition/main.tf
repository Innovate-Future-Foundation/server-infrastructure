resource "aws_ecs_task_definition" "main" {
  family                   = var.task_family
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name  = "postgres"
      image = var.postgres_image
      essential = true
      portMappings = [
        {
          containerPort = 5432
          hostPort      = 5432
        }
      ]
    },
    {
      name  = "db-migration"
      image = "${var.ecr_repository_url}:${var.db_migration_image}"
      essential = false
      dependsOn = [
        {
          containerName = "postgres"
          condition     = "HEALTHY"
        }
      ]
    },
    {
      name  = "backend-api"
      image = "${var.ecr_repository_url}:${var.backend_api_image}"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      dependsOn = [
        {
          containerName = "db-migration"
          condition     = "SUCCESS"
        }
      ]
    }
  ])
}

output "task_definition_arn" {
  value = aws_ecs_task_definition.main.arn
}
