variable "cluster_name" {
  description = "ECS cluster name"
  type        = string
}

variable "families" {
  description = "Task definition family name"
  type = map(object({
    role       = string
    name       = string
    cpu        = number
    mem        = number
    containers = string
  }))
}
