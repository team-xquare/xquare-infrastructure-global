resource "aws_iam_policy" "s3_policy" {
   name        = "xquare-s3-policy"
   policy      = data.aws_iam_policy_document.s3_policy_document.json
}

data "aws_iam_policy_document" "s3_policy_document" {
  statement {
    actions   = ["s3:ListAllMyBuckets"]
    resources = ["arn:aws:s3:::*"]
    effect = "Allow"
  }
  statement {
    actions   = ["s3:*"]
    resources = [
        aws_s3_bucket.prod_storage.arn,
        aws_s3_bucket.stag_storage.arn
    ]
    effect = "Allow"
  }
}

data "aws_iam_policy" "sqs_policy" {
  arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}