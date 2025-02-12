variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-west-1"
}

variable "name" {
  description = "The name of the JWT secret in AWS Secrets Manager"
  type        = string
  default     = "my-jwt-secret"
}

variable "description" {
  description = "Description for the JWT secret"
  type        = string
  default     = "JWT Secret for authentication"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {
    Environment = "Production"
    Project     = "MyApp"
  }
}
