variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-west-1"
}

variable "description" {
  description = "Description for the secrets"
  type        = string
  default     = "Secrets managed by Terraform"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {
    Environment = "Production"
    Project     = "MyApp"
  }
}
