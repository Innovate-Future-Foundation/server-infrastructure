variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "ap-northeast-3"
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

#second version
variable "secrets" {
  description = "A map of secrets to be created"
  type = map(string)

  default = {
    "secret-1" = "secret-1"
  }

}
