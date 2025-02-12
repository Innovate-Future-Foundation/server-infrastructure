output "jwt_secret_arn" {
  value       = module.jwt_secret.secret_arn
  description = "The ARN of the created JWT secret in AWS Secrets Manager"
}

output "jwt_secret_name" {
  value       = module.jwt_secret.secret_name
  description = "The name of the created JWT secret in AWS Secrets Manager"
}

