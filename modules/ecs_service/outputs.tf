output "ecs_service_id" {
  value = aws_ecs_service.main.id
}

output "ecs_service_name" {
  value = aws_ecs_service.main.name
}
