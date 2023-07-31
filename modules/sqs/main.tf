module "sqs" {
  source = "terraform-aws-modules/sqs/aws"
  name   = "${var.name_prefix}-queue.fifo"

  fifo_queue = var.fifo_queue
  content_based_deduplication = var.content_based_deduplication
}

resource "aws_sqs_queue_policy" "sqs_policy" {
  queue_url = module.sqs.queue_id

  policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Id": "sqspolicy",
    "Statement": [
      {
        "Sid": "First",
        "Effect": "Allow",
        "Principal": "*",
        "Action": "sqs:SendMessage",
        "Resource": "${module.sqs.queue_arn}"
      }
    ]
  }
  POLICY
}
