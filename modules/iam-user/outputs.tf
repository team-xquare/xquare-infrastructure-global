
output "iam_user_name" {
  description = "The user's name"
  value       = module.iam_user.iam_user_name
}

output "iam_user_arn" {
  description = "The ARN assigned by AWS for this user"
  value       =  module.iam_user.iam_user_arn
}

output "iam_user_unique_id" {
  description = "The unique ID assigned by AWS"
  value       = module.iam_user.iam_user_unique_id
}

output "iam_access_key_id" {
  description = "The access key ID"
  value       = module.iam_user.iam_access_key_id
}

output "iam_access_key_secret" {
  description = "The access key secret"
  value       = module.iam_user.iam_access_key_secret
  sensitive   = true
}

output "policy_arns" {
  description = "The list of ARNs of policies directly assigned to the IAM user"
  value       = module.iam_user.policy_arns
}