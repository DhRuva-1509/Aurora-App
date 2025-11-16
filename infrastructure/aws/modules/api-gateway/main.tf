
# Resource path:  /asr

resource "aws_api_gateway_resource" "resource" {
  rest_api_id = var.rest_api_id
  parent_id   = var.rest_api_root_id
  path_part   = var.path
}

# Method: POST /asr (protected by Cognito authorizer)

resource "aws_api_gateway_method" "method" {
  rest_api_id   = var.rest_api_id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = var.http_method
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = var.authorizer_id
}

# Integration: Lambda proxy

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = var.rest_api_id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.method.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = var.lambda_invoke_arn
}

# Lambda permission for API Gateway

resource "aws_lambda_permission" "allow_apigw" {
  statement_id  = "AllowInvokeViaAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.rest_api_execution_arn}/*/*"
}

# Deployment + Stage

resource "aws_api_gateway_deployment" "deploy" {
  depends_on = [aws_api_gateway_integration.integration]

  rest_api_id = var.rest_api_id
}

resource "aws_api_gateway_stage" "stage" {
  rest_api_id   = var.rest_api_id
  deployment_id = aws_api_gateway_deployment.deploy.id
  stage_name    = var.stage_name
}

