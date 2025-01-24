resource "aws_ecs_task_definition" "main" {
  family                   = var.family
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.execution_role_arn
  container_definitions    = jsonencode(var.container_definitions)

  tags = {
    Name = "${var.environment}-task-definition"
  }
}