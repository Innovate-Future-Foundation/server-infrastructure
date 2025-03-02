output "cluster_name" {
  description = "ECS cluster name"
  value       = aws_ecs_cluster.this.name
}

output "cluster_id" {
  description = "ECS cluster id"
  value       = aws_ecs_cluster.this.id
}

output "task_family_arns" {
  description = "Task definition ARN"
  value = {
    for k, v in aws_ecs_task_definition.this : k => v.arn
  }
}

output "task_role_arns" {
  description = "Task Role ARN"
  value = {
    for k, v in aws_iam_role.task_role : k => v.arn
  }
}
