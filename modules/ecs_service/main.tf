resource "aws_ecs_service" "main" {
  name            = var.service_name
  cluster         = var.cluster_name
  task_definition = var.task_definition_arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = var.security_group_ids
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  deployment_controller {
    type = "ECS"
  }

  service_registries {
    registry_arn = var.cloudmap_service_arn
    container_name = var.container_name
    container_port = var.container_port
  }

  tags = {
    Name = "${var.environment}-ecs-service"
  }
}
