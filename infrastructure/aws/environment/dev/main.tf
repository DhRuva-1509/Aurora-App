provider "aws" {
  region  = "ca-central-1"
  profile = "aurora-genAI-ios"

  shared_credentials_files = ["~/.aws/credentials"]

  assume_role {
    role_arn     = "arn:aws:iam::796973501829:role/aurora-genAI-Cognito"
    session_name = "terraform-session"
  }
}

# 1. CREATE THE REST API
resource "aws_api_gateway_rest_api" "aurora_api" {
  name = "aurora-mobile-api-dev"
}

# 2. LAMBDA MODULE — ASR HANDLER
module "asr_lambda" {
  source  = "../../modules/lambda"

  name     = "aurora-asr-handler"
  handler  = "asr.lambda_handler"
  runtime  = "python3.11"
  zip_path = var.lambda_zip_path
  timeout  = 30

  sqs_arn = module.asr_queue.queue_arn
  sqs_url = module.asr_queue.queue_url
}

# 3. COGNITO AUTHORIZER

module "cognito_authorizer" {
  source        = "../../modules/authorizer"
  user_pool_id  = var.cognito_user_pool_id
  rest_api_id   = aws_api_gateway_rest_api.aurora_api.id
}

# 4. API GATEWAY MODULE (POST /asr)

module "asr_api" {
  source = "../../modules/api-gateway"

  rest_api_id            = aws_api_gateway_rest_api.aurora_api.id
  rest_api_root_id       = aws_api_gateway_rest_api.aurora_api.root_resource_id
  rest_api_execution_arn = aws_api_gateway_rest_api.aurora_api.execution_arn

  path                  = "asr"
  http_method           = "POST"
  stage_name            = var.stage_name

  lambda_invoke_arn     = module.asr_lambda.invoke_arn
  lambda_function_name  = module.asr_lambda.function_name

  authorizer_id         = module.cognito_authorizer.authorizer_id

  region                = var.aws_region
}

# 5. SQS QUEUE (ASR → WORKER)

module "asr_queue" {
  source     = "../../modules/sqs"
  queue_name = "aurora-asr-queue"
}

# 6. BERT WORKER LAMBDA (Triggered by SQS)

module "lambda_bert" {
  source  = "../../modules/lambda-bert"

  name     = "aurora-bert-worker"
  handler  = "bert_worker.lambda_handler"
  runtime  = "python3.11"
  zip_path = var.lambda_worker_zip_path
  timeout  = 30

  sqs_arn = module.asr_queue.queue_arn
}
# 7. OUTPUTS

output "api_invoke_url" {
  description = "Invoke URL for POST /asr endpoint"
  value       = module.asr_api.invoke_url
}

output "sqs_queue_arn" {
  value = module.asr_queue.queue_arn
}

output "bert_worker_lambda" {
  value = module.lambda_bert.function_name
}
