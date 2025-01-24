# Create a Private DNS Namespace
resource "aws_service_discovery_private_dns_namespace" "namespace" {
  name        = var.namespace_name
  description = "Private DNS namespace for ECS service discovery"
  vpc         = var.namespace_vpc_id
}

# Register ECS Service with CloudMap
resource "aws_service_discovery_service" "service" {
  name = var.ecs_service_name

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.namespace.id

    dns_records {
      type = "SRV"
      ttl  = var.dns_ttl
    }
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}
