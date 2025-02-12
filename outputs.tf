output "secret_1_arn" {
  value       = module.secrets-manager.secret_1_arn
  description = "The ARN of secret-1 in AWS Secrets Manager."
}

output "secret_1_name" {
  value       = module.secrets-manager.secret_1_name
  description = "The name of secret-1 in AWS Secrets Manager."
}

output "secret_2_arn" {
  value       = module.secrets-manager.secret_2_arn
  description = "The ARN of secret-2 in AWS Secrets Manager."
}

output "secret_2_name" {
  value       = module.secrets-manager.secret_2_name
  description = "The name of secret-2 in AWS Secrets Manager."
}

output "secret_3_arn" {
  value       = module.secrets-manager.secret_3_arn
  description = "The ARN of secret-3 in AWS Secrets Manager."
}

output "secret_3_name" {
  value       = module.secrets-manager.secret_3_name
  description = "The name of secret-3 in AWS Secrets Manager."
}
