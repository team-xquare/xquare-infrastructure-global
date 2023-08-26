locals {
  prod_storage_name   = "xquare-prod-bucket"
  stag_storage_name   = "xquare-stag-bucket"
  thanos_storage_name = "xquare-thanos-bucket"
}

resource "aws_s3_bucket" "prod_storage" {
  bucket = local.prod_storage_name
}

resource "aws_s3_bucket" "stag_storage" {
  bucket = local.stag_storage_name
}

resource "aws_s3_bucket" "thanos_storage" {
  bucket = local.thanos_storage_name
}
