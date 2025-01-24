output "ecs_service_name" {
  description = "Name of the ECS service"
  value       = module.ecs_service.ecs_service_name
}

output "task_definition_arn" {
  description = "ARN of the ECS task definition"
  value       = module.ecs_task_definition.task_definition_arn
}

output "cloudmap_namespace_name" {
  description = "Name of the CloudMap namespace"
  value       = module.cloudmap.cloudmap_namespace_id
}
