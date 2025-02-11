output "namespace_id" {
  description = "Cloud Map namespace ID"
  value       = aws_service_discovery_private_dns_namespace.main.id
}
