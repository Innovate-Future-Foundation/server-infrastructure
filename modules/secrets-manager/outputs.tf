
output "secret_arn" {
  value       = aws_secretsmanager_secret.jwt_secret.arn
  description = "The ARN of the created AWS Secrets Manager secret."
}

output "secret_name" {
  value       = aws_secretsmanager_secret.jwt_secret.name
  description = "The name of the created AWS Secrets Manager secret."
}
