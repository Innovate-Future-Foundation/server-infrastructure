resource "aws_ecs_cluster" "main" {
  name = var.cluster_name

}

# resource "aws_ecs_cluster_capacity_providers" "main" {
#   cluster_name = aws_ecs_cluster.main.name

#   capacity_providers = ["FARGATE", "FARGATE_SPOT"]

#   default_capacity_provider_strategy {
#     base              = 1
#     weight            = 100
#     capacity_provider = "FARGATE"
#   }
# }



# resource "aws_vpc" "main" {
#   cidr_block = var.vpc_cidr
  
#   enable_dns_hostnames = true
#   enable_dns_support   = true

#   tags = merge(var.tags, {
#     Name = "${var.cluster_name}-vpc"
#   })
# }

# Create subnets for your cluster
# resource "aws_subnet" "private" {
#   count             = length(var.private_subnet_cidrs)
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = var.private_subnet_cidrs[count.index]
#   availability_zone = var.availability_zones[count.index]

#   tags = merge(var.tags, {
#     Name = "${var.cluster_name}-private-subnet-${count.index + 1}"
#   })
# }

# Security group for ECS tasks
# resource "aws_security_group" "ecs_tasks" {
#   name        = "${var.cluster_name}-sg-ecs-tasks"
#   description = "Allow inbound access to ECS tasks from the ALB only"
#   vpc_id      = aws_vpc.main.id

#   ingress {
#     protocol        = "tcp"
#     from_port       = var.container_port
#     to_port         = var.container_port
#     cidr_blocks     = ["0.0.0.0/0"]
#   }

#   egress {
#     protocol    = "-1"
#     from_port   = 0
#     to_port     = 0
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = var.tags
# }



  



