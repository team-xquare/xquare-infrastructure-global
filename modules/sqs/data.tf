data "aws_iam_policy_document" "sqs_policy" {
  statement {
    sid    = "First"
    effect = "Allow"

    principals {
      type = "*"
      identifiers = ["*"]
    }

    actions = ["sqs:SendMessage"]
    resources = [module.sqs.queue_arn]
  }
}