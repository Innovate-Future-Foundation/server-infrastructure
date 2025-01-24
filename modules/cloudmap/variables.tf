variable "namespace_name" {
  description = "The name of the Cloud Map namespace"
  type        = string
}

variable "namespace_vpc_id" {
  description = "The VPC ID where the namespace will be created"
  type        = string
}

variable "ecs_service_name" {
  description = "The name of the service to be registered in the namespace"
  type        = string
}

variable "dns_ttl" {
  description = "TTL for DNS records created for the service"
  type        = number
  default     = 60
}