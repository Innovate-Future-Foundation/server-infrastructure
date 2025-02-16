# Create an ECS cluster 
resource "aws_ecs_cluster" "main" {
  name = var.cluster_name
}

# Define a multi-container task with four containers: postgres, migration, api, pgadmin
resource "aws_ecs_task_definition" "main" {
  family                   = var.family
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.execution_role_arn

  container_definitions = var.container_definitions

  # Do not track containers configuration
  lifecycle {
    ignore_changes = [container_definitions]
  }
}

# Create an ECS service to run the multi-container task
resource "aws_ecs_service" "main" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnets
    security_groups  = var.security_groups
    assign_public_ip = var.assign_public_ip
  }

  service_registries {
    registry_arn = var.registry_arn
    port         = 5091
  }

  # Do not track task definition and desired task count
  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
}
