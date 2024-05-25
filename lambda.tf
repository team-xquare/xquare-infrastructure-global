locals {
  spot_function_runtime = "python3.7"
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