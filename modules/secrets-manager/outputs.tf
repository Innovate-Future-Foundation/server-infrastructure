output "secret_1_arn" {
  value       = aws_secretsmanager_secret.secret-1.arn
  description = "The ARN of the created AWS Secrets Manager secret-1."
}

output "secret_1_name" {
  value       = aws_secretsmanager_secret.secret-1.name
  description = "The name of the created AWS Secrets Manager secret-1."
}

output "secret_2_arn" {
  value       = aws_secretsmanager_secret.secret-2.arn
  description = "The ARN of the created AWS Secrets Manager secret-2."
}

output "secret_2_name" {
  value       = aws_secretsmanager_secret.secret-2.name
  description = "The name of the created AWS Secrets Manager secret-2."
}

output "secret_3_arn" {
  value       = aws_secretsmanager_secret.secret-3.arn
  description = "The ARN of the created AWS Secrets Manager secret-3."
}

output "secret_3_name" {
  value       = aws_secretsmanager_secret.secret-3.name
  description = "The name of the created AWS Secrets Manager secret-3."
}
