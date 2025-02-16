output "ecs_cluster_name" {
  description = "ECS cluster name"
  value       = module.ecs_multi.cluster_name
}

output "ecs_service_name" {
  description = "ECS service name for multi-container task"
  value       = module.ecs_multi.service_name
}
