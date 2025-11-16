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
