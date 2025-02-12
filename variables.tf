variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "ap-southeast-2"
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

variable "secrets" {
  description = "A map of secrets to be created"
  type        = map(string)
  default     = {
    "secret-1" = "secret-1",
    "secret-2" = "secret-2",
    "secret-3" = "secret-3"
    # Add more secrets as needed, e.g.,:
    # "secret-4" = "secret-4"
  }
}
