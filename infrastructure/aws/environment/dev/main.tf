provider "aws" {
  region  = "ca-central-1"
  profile = "aurora-genAI-ios"

  shared_credentials_files = ["~/.aws/credentials"]

  assume_role {
    role_arn     = "arn:aws:iam::796973501829:role/aurora-genAI-Cognito"
    session_name = "terraform-session"
  }
}

module "cognito" {
  source = "../../modules/cognito"

  project_name = "aurora-mobile"
  environment  = "dev"
}
