variable "name" { 
    type = string
 }
 
variable "handler" { 
    type = string 
}

variable "runtime" { 
    type = string 
}

variable "zip_path" { 
    type = string 
}

variable "timeout" {
  type    = number
  default = 30
}
variable "sqs_arn" {
  description = "SQS Queue ARN for permissions"
  type        = string
  default     = null
}

variable "sqs_url" {
  description = "SQS Queue URL for sending messages"
  type        = string
  default     = null
}
