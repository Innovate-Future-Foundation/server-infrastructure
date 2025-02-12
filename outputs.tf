output "secret_arns" {
  value       = module.secrets-manager.secret_arns
  description = "The ARNs of all created AWS Secrets Manager secrets."
}

output "secret_names" {
  value       = module.secrets-manager.secret_names
  description = "The names of all created AWS Secrets Manager secrets."
}
