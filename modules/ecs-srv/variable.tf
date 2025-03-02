variable "name" {
  description = "ECS Service Name"
  type        = string
}

variable "cluster" {
  description = "The ECS Cluster ID"
  type        = string
}

variable "family" {
  description = "The task definition arn"
  type        = string
}

variable "desired_count" {
  description = "Desired task count for service"
  type        = number
  default     = 0
}

# Currently does not support customisation
variable "launch_type" {
  description = "Launch type of ECS service"
  type        = string
  default     = "FARGATE"
  validation {
    condition     = contains(["FARGATE"], var.launch_type)
    error_message = "Currently only support 'FARGATE'"
  }
}

variable "network" {
  description = "Network setting block"
  type = object({
    subnets         = list(string)
    security_groups = list(string)
    assign_pub_ip   = bool
  })
}

variable "srv_registry" {
  type = object({
    registry_arn   = string
    container_name = string
    container_port = number
  })
}
