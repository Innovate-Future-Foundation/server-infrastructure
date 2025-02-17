locals {
  integration_ids = merge(
    { for k, v in aws_apigatewayv2_integration.private_cloud_map : k => v.id },
    # { for k, v in aws_aws_apigatewayv2_integration.private_alb : k => v.id },
  )
}

resource "aws_apigatewayv2_api" "this" {
  name          = var.name
  description   = var.description
  protocol_type = "HTTP"

  cors_configuration {
    allow_headers = ["content-type", "authorization", "*"]
    allow_methods = ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
    allow_origins = ["*"]
  }
}

# Create VPC Link
resource "aws_apigatewayv2_vpc_link" "this" {
  for_each           = var.vpc_links
  name               = "${each.value.name}-vpc-link"
  security_group_ids = each.value.security_groups
  subnet_ids         = each.value.subnets
}

# Private integration for Cloud Map Service Registry
resource "aws_apigatewayv2_integration" "private_cloud_map" {
  for_each           = var.cloud_map_integrations
  api_id             = aws_apigatewayv2_api.this.id
  integration_type   = "HTTP_PROXY"
  integration_method = "ANY"
  integration_uri    = each.value.service
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.this[each.value.vpc_link].id
}

# Private integration for ALB/NLB Listener
# resource "aws_apigatewayv2_integration" "private_alb" {
#   for_each = var.alb_integrations
# }

# API route for /api/v1/{proxy+}
resource "aws_apigatewayv2_route" "this" {
  for_each  = var.routes
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "${each.value.method} ${each.value.path}"
  target    = "integrations/${local.integration_ids[each.value.integration]}"
}

resource "aws_apigatewayv2_stage" "this" {
  api_id      = aws_apigatewayv2_api.this.id
  name        = "$default"
  auto_deploy = true
}
