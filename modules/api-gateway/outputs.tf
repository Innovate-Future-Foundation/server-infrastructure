output "api_id" {
  description = "ID of the HTTP API"
  value       = aws_apigatewayv2_api.this.id
}

output "api_endpoint" {
  description = "HTTP API endpoint URL"
  value       = aws_apigatewayv2_api.this.api_endpoint
}

output "stage_id" {
  description = "ID of the default stage"
  value       = aws_apigatewayv2_stage.this.id
}
