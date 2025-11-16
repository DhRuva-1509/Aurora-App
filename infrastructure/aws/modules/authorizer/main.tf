data "aws_cognito_user_pool" "pool" {
  user_pool_id = var.user_pool_id
}

resource "aws_api_gateway_authorizer" "cognito" {
  name            = "CognitoJWTAuthorizer"
  rest_api_id     = var.rest_api_id
  type            = "COGNITO_USER_POOLS"
  provider_arns   = [data.aws_cognito_user_pool.pool.arn]
  identity_source = "method.request.header.Authorization"
}
