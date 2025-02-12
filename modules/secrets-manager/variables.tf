variable "name" {
  description = "The name of the secret in AWS Secrets Manager."
  type        = string
}

variable "description" {
  description = "A description for the secret."
  type        = string
}

variable "tags" {
  description = "Tags to apply to the AWS Secrets Manager secret."
  type        = map(string)
}
}
