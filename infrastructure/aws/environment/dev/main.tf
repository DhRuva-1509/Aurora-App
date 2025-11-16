provider "aws" {
  region  = "ca-central-1"
  profile = "aurora-genAI-ios"

  shared_credentials_files = ["~/.aws/credentials"]

  assume_role {
    role_arn     = "arn:aws:iam::796973501829:role/aurora-genAI-Cognito"
    session_name = "terraform-session"
  }
}

#############################################
# 1. CREATE THE REST API (ONLY ONCE)
#############################################

resource "aws_api_gateway_rest_api" "aurora_api" {
  name = "aurora-mobile-api-dev"
}


#############################################
# 2. LAMBDA MODULE — ASR HANDLER
#############################################

module "asr_lambda" {
  source  = "../../modules/lambda"

  name     = "aurora-asr-handler"
  handler  = "asr.lambda_handler"
  runtime  = "python3.11"
  zip_path = var.lambda_zip_path
  timeout  = 30
}


#############################################
# 3. REMOVE temp_api (THIS WAS WRONG)
#############################################
# ❌ DELETE THIS — DO NOT INCLUDE THIS ANYMORE
# resource "aws_api_gateway_rest_api" "temp_api" {
#   name = "aurora-api-dev"
# }


#############################################
# 4. COGNITO AUTHORIZER (on SAME REST API)
#############################################

module "cognito_authorizer" {
  source        = "../../modules/authorizer"
  user_pool_id  = var.cognito_user_pool_id
  rest_api_id   = aws_api_gateway_rest_api.aurora_api.id
}


#############################################
# 5. API GATEWAY MODULE (POST /asr)
#############################################

module "asr_api" {
  source = "../../modules/api-gateway"

  rest_api_id           = aws_api_gateway_rest_api.aurora_api.id
  rest_api_root_id      = aws_api_gateway_rest_api.aurora_api.root_resource_id
  rest_api_execution_arn = aws_api_gateway_rest_api.aurora_api.execution_arn

  path                  = "asr"
  http_method           = "POST"
  stage_name            = var.stage_name

  lambda_invoke_arn     = module.asr_lambda.invoke_arn
  lambda_function_name  = module.asr_lambda.function_name

  authorizer_id         = module.cognito_authorizer.authorizer_id

  region                = var.aws_region
}


#############################################
# 6. OUTPUTS
#############################################

output "api_invoke_url" {
  description = "Invoke URL for POST /asr endpoint"
  value       = module.asr_api.invoke_url
}

