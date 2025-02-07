variable "location" {
  description = "aws location"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR for vpc"
  type        = string
}

variable "api_subnet_cidr" {
  description = "CIDR block for ecs resources"
  type        = string
}

variable "tool_subnet_cidr" {
  description = "CIDR block for tool resources"
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR block for private subnet"
}

variable "subnet_az" {
  description = "subnet availability zone"
  type        = string
}

variable "backend_sg_name" {
  description = "security group for backend"
  type        = string
}

variable "web_tool_sg_name" {
  description = "security group for tools like pgadmin"
  type        = string
}
