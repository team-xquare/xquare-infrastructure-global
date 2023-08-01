module "sqs" {
  source                      = "terraform-aws-modules/sqs/aws"
  name                        = "${var.name_prefix}-queue"
  fifo_queue                  = var.fifo_queue
  content_based_deduplication = var.content_based_deduplication
}