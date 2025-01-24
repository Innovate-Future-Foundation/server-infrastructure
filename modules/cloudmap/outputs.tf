output "cloudmap_namespace_id" {
  description = "The ID of the created Cloud Map namespace"
  value       = aws_service_discovery_private_dns_namespace.namespace.id
}

output "cloudmap_service_arn" {
  description = "The ARN of the Cloud Map service"
  value       = aws_service_discovery_service.service.arn
}

output "route53_dns_name" {
  description = "The DNS name created for the service in Route 53"
  value       = aws_service_discovery_private_dns_namespace.namespace.name
}

