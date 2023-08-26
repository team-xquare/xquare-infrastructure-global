variable "name" {
  description = "The user's name"
  type = string
}

variable "create_iam_user_login_profile" {
  description = "Whether to create IAM user login profile"
  type        = bool
  default     = false
}

variable "create_iam_access_key" {
  description = "Whether to create IAM access key"
  type        = bool
  default     = false
}

variable "policy_arns" {
  description = "The list of ARNs of policies directly assigned to the IAM user"
  type        = list(string)
  default     = []
}