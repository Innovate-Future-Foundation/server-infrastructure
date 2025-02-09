output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "Map of public subnet IDs"
  value       = { for k, v in aws_subnet.public : k => v.id }
}

output "private_subnet_ids" {
  description = "Map of private subnet IDs"
  value       = { for k, v in aws_subnet.private : k => v.id }
}

output "security_group_ids" {
  description = "Map of security group names to their IDs"
  value = {
    for k, v in aws_security_group.sg : k => v.id
  }
}
