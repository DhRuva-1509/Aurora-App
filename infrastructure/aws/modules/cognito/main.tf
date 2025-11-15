#Module: Cognito User

resource "aws_cognito_user_pool" "this" {
  name = "${var.project_name}-user-pool-${var.environment}"

  # Sign-up attributes
  auto_verified_attributes = ["email"]
  username_attributes = [ "email" ]

  schema {
    name = "email"
    required = true
    attribute_data_type = "String"
    mutable = false
  }

  schema {
    name = "name"
    required = true
    attribute_data_type = "String"
    mutable = true
  }

  password_policy {
    minimum_length = 8
    require_uppercase = true
    require_lowercase = true
    require_numbers = true
    require_symbols = true
  }

  admin_create_user_config {
    allow_admin_create_user_only = false
  }
}

# Cognito User Pool Client
resource "aws_cognito_user_pool_client" "this" {
  name = "${var.project_name}-client-${var.environment}"
  user_pool_id = aws_cognito_user_pool.this.id
  generate_secret = false

  # Authentication flows for SDK
  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_CUSTOM_AUTH"
  ]

  access_token_validity = 60
  id_token_validity = 60
  refresh_token_validity = 30
  token_validity_units {
    access_token = "minutes"
    id_token = "minutes"
    refresh_token = "days"
  }

  prevent_user_existence_errors = "ENABLED"
}

# Identity Pool for AWS SDK
resource "aws_cognito_identity_pool" "this" {
  identity_pool_name = "${var.project_name}-identity-${var.environment}"
  allow_unauthenticated_identities = false
  
  cognito_identity_providers {
    client_id = aws_cognito_user_pool_client.this.id
    provider_name = aws_cognito_user_pool.this.endpoint
    server_side_token_check = true
  }
}
