# Create an ECS service to run the multi-container task
resource "aws_ecs_service" "this" {
  name            = var.name
  cluster         = var.cluster
  task_definition = var.family
  desired_count   = var.desired_count
  launch_type     = var.launch_type

  network_configuration {
    subnets          = var.network.subnets
    security_groups  = var.network.security_groups
    assign_public_ip = var.network.assign_pub_ip
  }

  service_registries {
    registry_arn   = var.srv_registry.registry_arn
    container_name = var.srv_registry.container_name
    container_port = var.srv_registry.container_port
  }

  # Do not track task definition and desired task count
  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
}
