output "api_gateway_url" {
  description = "URL del API Gateway"
  value       = aws_apigatewayv2_stage.main.invoke_url
}

output "dynamodb_table_name" {
  description = "Nombre de la tabla DynamoDB"
  value       = aws_dynamodb_table.main.name
}

output "lambda_function_name" {
  description = "Nombre de la función Lambda"
  value       = aws_lambda_function.main.function_name
}

