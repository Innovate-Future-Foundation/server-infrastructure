resource "aws_service_discovery_private_dns_namespace" "main" {
  name        = var.namespace
  description = var.description
  vpc         = var.vpc_id
}
