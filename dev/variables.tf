variable "location" {
  description = "aws location"
  type        = string
  default     = "ap-southeast-2"
}

variable "api_port" {
  description = "Dotnet API port number"
  type        = number
  default     = 5091
}

variable "db_port" {
  description = "Postgres DB port number"
  type        = number
  default     = 5432
}

variable "web_port" {
  description = "General Web port number"
  type        = number
  default     = 80
}

variable "vpc_cidr" {
  description = "CIDR for vpc"
  type        = string
  default     = "10.1.0.0/16"
}

variable "api_subnet_cidr" {
  description = "CIDR block for ecs resources"
  type        = string
  default     = "10.1.0.0/20"
}

variable "tool_subnet_cidr" {
  description = "CIDR block for tool resources"
  type        = string
  default     = "10.1.16.0/20"
}

variable "private_subnet_cidr" {
  description = "CIDR block for private subnet"
  default     = "10.1.32.0/20"
}

variable "subnet_az" {
  description = "subnet availability zone"
  type        = string
  default     = "ap-southeast-2"
}
