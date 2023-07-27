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
      module.thanos_storage.bucket_arn,
      "${module.thanos_storage.bucket_arn}/*"
    ]
  }
}
