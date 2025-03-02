output "service_name" {
  description = "ECS Service name"
  value       = aws_ecs_service.this.name
}

output "service_id" {
  description = "ECS Service ID"
  value       = aws_ecs_service.this.id
}
