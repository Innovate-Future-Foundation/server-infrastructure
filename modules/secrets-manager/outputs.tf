output "secret_arns" {
  value       = { for key, secret in aws_secretsmanager_secret.secrets : key => secret.arn }
  description = "The ARNs of all created AWS Secrets Manager secrets."
}

output "secret_names" {
  value       = { for key, secret in aws_secretsmanager_secret.secrets : key => secret.name }
  description = "The names of all created AWS Secrets Manager secrets."
}
