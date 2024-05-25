locals {
  spot_function_runtime = "python3.12"
  spot_function_name = "spot_termination_notification"
  spot_function_source_path = "spot-notification"
  spot_function_handler = "lambda_function.lambda_handler"
  spot_function_description = "스팟 종료 알림 함수"
}

module "spot_handler_function" {
  source = "./modules/lambda"

  function_name = local.spot_function_name
  description = local.spot_function_description
  handler = local.spot_function_handler
  source_path = local.spot_function_source_path
  runtime = local.spot_function_runtime
  iam_role = aws_iam_role.lambda_role.arn

  custom_environment_variables = {
    hookUrl = var.slack_hook_url
    slackChannel = var.slack_channel
  }
}

resource "aws_cloudwatch_event_rule" "spot_instance_interruption" {
  name        = "spot-instance-interruption-warning"
  description = "Triggers on EC2 Spot Instance Interruption Warnings"
  event_pattern = jsonencode({
    source = ["aws.ec2"],
    "detail-type" = ["EC2 Spot Instance Interruption Warning"]
  })
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.spot_instance_interruption.name
  target_id = "lambda-target"
  arn       = module.spot_handler_function.this_lambda_function_arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = module.spot_handler_function.this_lambda_function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.spot_instance_interruption.arn
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_role_with_ec2_permissions"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
  name   = "lambda_policy_with_ec2_permissions"
  role   = aws_iam_role.lambda_role.name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement: [
      {
        Effect: "Allow",
        Action: [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource: "*"
      },
      {
        Sid: "GetDetailedInfoFromInterruptedSpotInstance",
        Effect: "Allow",
        Action: [
          "ec2:DescribeInstances",
          "ec2:DescribeTags"
        ],
        Resource: "*",
        Condition: {
          StringEquals: {
            "ec2:Region": "ap-northeast-2"
          }
        }
      }
    ]
  })
}