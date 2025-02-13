variable "repositories" {
  description = "Map of ECR repositories to create"
  type = map(object({
    name        = string
    description = string
  }))
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}