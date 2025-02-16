resource "aws_service_discovery_private_dns_namespace" "main" {
  name        = var.namespace
  description = var.description
  vpc         = var.vpc_id
}

resource "aws_service_discovery_service" "main" {
  for_each = var.services
  name     = each.value.name

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.main.id
    dynamic "dns_records" {
      for_each = each.value.dns_records
      content {
        ttl  = dns_records.value.ttl
        type = dns_records.value.type
      }
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}
