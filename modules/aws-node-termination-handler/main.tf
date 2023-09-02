resource "aws_sqs_queue" "queue" {
  name                      = var.default_name
  message_retention_seconds = 300
  kms_master_key_id         = aws_kms_key.kms_key.id
}

resource "aws_iam_policy" "queue_access_policy" {
  queue_url = aws_sqs_queue.queue.id

  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "NTHQueuePolicy",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "sqs:SendMessage",
        Resource  = aws_sqs_queue.queue.arn,
      },
    ],
  })
}

resource "aws_iam_role" "queue_access_role" {
  name = "nth-autoscaling-sqs-access-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "queue_access_attachment" {
  name       = "sqs-access-attachment"
  policy_arn = aws_iam_policy.queue_access_policy.arn
  roles      = [aws_iam_role.queue_access_role.name]
}

resource "aws_kms_key" "kms_key" {
  description             = "Example KMS Key"
  deletion_window_in_days = 30
}

resource "aws_autoscaling_lifecycle_hook" "autoscaling_lifecycle_hook" {
  name                 = "${var.default_name}-hook"
  autoscaling_group_name = var.default_name
  lifecycle_transition = "autoscaling:EC2_INSTANCE_TERMINATING"
  default_result      = "CONTINUE"
  heartbeat_timeout   = 300
  notification_target_arn = aws_sqs_queue.queue.arn
  role_arn            = queue_access_role.arn
}

resource "aws_autoscaling_group" "asg" {
  name = var.default_name
  max_size                  = 6
  min_size                  = 3
  health_check_grace_period = 300

  tags = [
    {
      key                 = "aws-node-termination-handler/managed"
      value               = ""
      propagate_at_launch = true
    }
  ]
}

resource "aws_cloudwatch_event_rule" "k8s_asg_term_rule" {
  name        = "NTHK8sASGTermRule"
  description = "Event rule for EC2 Instance-terminate Lifecycle Action"
  event_pattern = jsonencode({
    source     = ["aws.autoscaling"],
    detail_type = ["EC2 Instance-terminate Lifecycle Action"]
  })
}

resource "aws_cloudwatch_event_target" "k8s_asg_term_target" {
  rule = aws_cloudwatch_event_rule.k8s_asg_term_rule.name
  arn  = aws_sqs_queue.queue.arn
}

resource "aws_cloudwatch_event_rule" "k8s_spot_term_rule" {
  name        = "NTHK8sSpotTermRule"
  description = "Event rule for EC2 Spot Instance Interruption Warning"
  event_pattern = jsonencode({
    source     = ["aws.ec2"],
    detail_type = ["EC2 Spot Instance Interruption Warning"]
  })
}

resource "aws_cloudwatch_event_target" "k8s_spot_term_target" {
  rule = aws_cloudwatch_event_rule.k8s_spot_term_rule.name
  arn  = aws_sqs_queue.queue.arn
}

resource "aws_cloudwatch_event_rule" "k8s_rebalance_rule" {
  name        = "NTHK8sRebalanceRule"
  description = "Event rule for EC2 Instance Rebalance Recommendation"
  event_pattern = jsonencode({
    source     = ["aws.ec2"],
    detail_type = ["EC2 Instance Rebalance Recommendation"]
  })
}

resource "aws_cloudwatch_event_target" "k8s_rebalance_target" {
  rule = aws_cloudwatch_event_rule.k8s_rebalance_rule.name
  arn  = aws_sqs_queue.queue.arn
  id   = "1"
}

resource "aws_cloudwatch_event_rule" "k8s_instance_state_change_rule" {
  name        = "NTHK8sInstanceStateChangeRule"
  description = "Event rule for EC2 Instance State-change Notification"
  event_pattern = jsonencode({
    source     = ["aws.ec2"],
    detail_type = ["EC2 Instance State-change Notification"]
  })
}

resource "aws_cloudwatch_event_target" "k8s_instance_state_change_target" {
  rule = aws_cloudwatch_event_rule.k8s_instance_state_change_rule.name
  arn  = aws_sqs_queue.queue.arn
  id   = "1"
}

resource "aws_cloudwatch_event_rule" "k8s_scheduled_change_rule" {
  name        = "NTHK8sScheduledChangeRule"
  description = "Event rule for AWS Health Event - scheduledChange"
  event_pattern = jsonencode({
    source     = ["aws.health"],
    detail_type = ["AWS Health Event"],
    detail = {
      service            = ["EC2"],
      eventTypeCategory = ["scheduledChange"]
    }
  })
}

resource "aws_cloudwatch_event_target" "k8s_scheduled_change_target" {
  rule = aws_cloudwatch_event_rule.k8s_scheduled_change_rule.name
  arn  = aws_sqs_queue.queue.arn
  id   = "1"
}

resource "aws_iam_policy" "eks_node_termination_handler_policy" {
  name        = "${var.default_name}_policy"
  description = "Policy for the aws-node-termination-handler pods"
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "autoscaling:CompleteLifecycleAction",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeTags",
          "ec2:DescribeInstances",
          "sqs:DeleteMessage",
          "sqs:ReceiveMessage",
        ],
        Resource = "*",
      },
    ],
  })
}

resource "aws_iam_role" "eks_node_termination_handler_role" {
  name = "${var.default_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity",
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com",
        }
      },
    ],
  })
}

resource "helm_release" "aws_node_termination_handler" {
  name       = var.chart-name
  namespace  = var.namespace
  repository = var.repository
  chart      = var.chart-name
  version    = var.chart-version

  set {
    name  = "queueURL"
    value = aws_sqs_queue.queue.arn
  }

  set {
    name  = "serviceAccount.annotations.eks.amazonaws.com/role-arn"
    value = aws_iam_role.eks_node_termination_handler_role.arn
  }
}