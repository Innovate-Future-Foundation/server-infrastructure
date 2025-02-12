
variable "description" {
  description = "A description for all the secrets."
  type        = string
  default     = "Managed by Terraform"
}

variable "tags" {
  description = "Tags to apply to all AWS Secrets Manager secrets."
  type        = map(string)
  default     = {}
}
