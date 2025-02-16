output "namespace_id" {
  description = "Cloud Map namespace ID"
  value       = aws_service_discovery_private_dns_namespace.main.id
}

output "service_arns" {
  description = "Private DNS Namespace Service Registries"
  value = {
    for k, v in aws_service_discovery_service.main : k => v.arn
  }
}
