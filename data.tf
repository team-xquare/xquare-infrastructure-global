data "aws_region" "current" {}

data "aws_iam_policy_document" "thanos_s3_policy" {
  version = "2012-10-17"
  statement {
    sid    = ""
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:PutObject",
    ]
    resources = [
      "arn:aws:s3:::${local.thanos_storage_name_prefix}-bucket",
      "arn:aws:s3:::${local.thanos_storage_name_prefix}-bucket/*",
    ]
  }
}
