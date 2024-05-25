variable "function_name" {
  type = string
}

variable "description" {
  type = string
}

variable "handler" {
  type = string
}

variable "runtime" {
  type = string
}

variable "source_path" {
  type = string
}

#variable "s3_bucket" {
#  type = string
#}

variable "iam_role" {
  description = "IAM Role for the Lambda function"
  type        = string
  default     = ""
}

variable "custom_environment_variables" {
  description = "Custom environment variables for the Lambda function"
  type        = map(string)
  default     = {}
}