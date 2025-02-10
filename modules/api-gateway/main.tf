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
  name               = "${var.name}-vpc-link"
  security_group_ids = var.security_group_ids
  subnet_ids         = var.subnet_ids
}

# API route for /api/v1/{proxy+}
resource "aws_apigatewayv2_route" "api" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "ANY /api/v1/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.api.id}"
}

# API route for /swagger/{proxy+}
resource "aws_apigatewayv2_route" "swagger" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "ANY /swagger/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.swagger.id}"
}

# VPC Link integration for API route
resource "aws_apigatewayv2_integration" "api" {
  api_id           = aws_apigatewayv2_api.this.id
  integration_type = "HTTP_PROXY"
  integration_method = "ANY"
  integration_uri    = var.service_arn
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.this.id
}

# VPC Link integration for Swagger route
resource "aws_apigatewayv2_integration" "swagger" {
  api_id           = aws_apigatewayv2_api.this.id
  integration_type = "HTTP_PROXY"
  integration_method = "ANY"
  integration_uri    = var.service_arn
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.this.id
}

resource "aws_apigatewayv2_stage" "this" {
  api_id = aws_apigatewayv2_api.this.id
  name   = "$default"
  auto_deploy = true
}