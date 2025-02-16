variable "vpc_id" {
  description = "VPC ID to associate with the private namespace"
  type        = string
}

variable "namespace" {
  description = "DNS namespace name"
  type        = string
}

variable "description" {
  type    = string
  default = "Private DNS namespace for service discovery"
}

variable "services" {
  description = "List of service registry"
  type = map(object({
    name = string
    dns_records = list(object({
      ttl  = string
      type = string
    }))
  }))
}
