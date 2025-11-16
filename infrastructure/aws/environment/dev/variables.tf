variable "aws_region" {
  default = "ca-central-1"
}

variable "lambda_zip_path" {
  type = string
}

variable "cognito_user_pool_id" {
  type        = string
  description = "Amplify-created Cognito User Pool ID"
}

variable "stage_name" {
  default = "dev"
}
variable "lambda_worker_zip_path" {
  description = "Path to the zip file for the BERT worker lambda"
  type        = string
}
