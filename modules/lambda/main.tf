module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = var.function_name
  description   = var.description
  handler       = var.handler
  runtime       = var.runtime
  publish       = true

  source_path = var.source_path

  store_on_s3 = true
  s3_bucket   = var.s3_bucket

  environment_variables = {
    Serverless = "Terraform"
  }
}
