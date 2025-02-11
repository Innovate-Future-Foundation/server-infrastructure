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
