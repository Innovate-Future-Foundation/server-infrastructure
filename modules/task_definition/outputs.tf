output "postgres_task_arn" {
  description = "ARN of the Postgres Task Definition"
  value       = aws_ecs_task_definition.postgres.arn
}

output "migration_task_arn" {
  description = "ARN of the Migration Task Definition"
  value       = aws_ecs_task_definition.migration.arn
}

output "api_task_arn" {
  description = "ARN of the API Task Definition"
  value       = aws_ecs_task_definition.api.arn
}
