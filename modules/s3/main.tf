resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_policy" "this" {
  count  = var.is_public ? 1 : 0

  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.public_access_bucket_policy_document.json
}

data "aws_iam_policy_document" "public_access_bucket_policy_document" {
  version = "2012-10-17"
  policy_id = "Policy1693145575478"
  statement {
    sid = "Stmt1693145559885"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      ]
    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*"
    ]
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  count                   = var.is_public ? 1 : 0

  bucket                  = aws_s3_bucket.this.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
