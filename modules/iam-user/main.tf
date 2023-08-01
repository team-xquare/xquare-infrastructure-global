
module "iam_user" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  name    = var.name
  
  policy_arns = var.policy_arns

  create_iam_user_login_profile = var.create_iam_user_login_profile
  create_iam_access_key         = var.create_iam_access_key
}
