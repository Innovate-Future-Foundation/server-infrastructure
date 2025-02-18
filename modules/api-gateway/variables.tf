variable "name" {
  description = "Name of the API Gateway"
  type        = string
}

variable "description" {
  description = "Description of the API Gateway"
  type        = string
  default     = "API Gateway managed by Terraform"
}

variable "vpc_links" {
  description = "VPC Links for private resource integrations"
  type = map(object({
    name            = string
    subnets         = list(string)
    security_groups = list(string)
  }))
  default = {}
}

variable "cloud_map_integrations" {
  description = "Private resource integrations using cloud map service registry"
  type = map(object({
    service  = string
    vpc_link = string
  }))
  default = {}
}

variable "routes" {
  description = "Routes settings for API Gateway"
  type = map(object({
    method      = string
    path        = string
    integration = string
  }))
  default = {}
}
