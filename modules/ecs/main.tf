locals {
  default_task_execution_policy = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Create an ECS cluster 
resource "aws_ecs_cluster" "main" {
  name = var.cluster_name
}

# Define task execution role
data "aws_iam_policy_document" "ecs_role_assume_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = var.task_execution_role
  assume_role_policy = data.aws_iam_policy_document.ecs_role_assume_policy.json
}

resource "aws_iam_policy_attachment" "ecs_task_execution_policy" {
  name       = "${var.task_execution_role}-policy-attachment"
  roles      = [aws_iam_role.ecs_task_execution_role.name]
  policy_arn = local.default_task_execution_policy
}

# Define a multi-container task with four containers: postgres, migration, api, pgadmin
resource "aws_ecs_task_definition" "main" {
  family                   = var.family
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

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
  desired_count   = 0
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnets
    security_groups  = var.security_groups
    assign_public_ip = var.assign_public_ip
  }

  service_registries {
    registry_arn   = var.registry_arn
    container_name = "api"
    container_port = 5091
  }

  # Do not track task definition and desired task count
  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
}
