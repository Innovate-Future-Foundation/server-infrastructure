output "log_group_names" {
  description = "Map of created CloudWatch log group names"
  value       = { for k, lg in aws_cloudwatch_log_group.this : k => lg.name }
}