#locals {
#  prod_storage_name   = "xquare-prod-bucket"
#  stag_storage_name   = "xquare-stag-bucket"
#  thanos_storage_name = "xquare-thanos-bucket"
#  loki_storage_name = "xquare-loki-bucket"
#}
#
#module "prod_storage" {
#  source = "./modules/s3"
#
#  bucket_name = local.prod_storage_name
#  is_public   = true
#}
#
#module "stag_storage" {
#  source = "./modules/s3"
#
#  bucket_name = local.stag_storage_name
#  is_public   = true
#}
#
#module "thanos_storage" {
#  source = "./modules/s3"
#
#  bucket_name = local.thanos_storage_name
#  is_public   = false
#}
#
#module "loki_storage" {
#  source = "./modules/s3"
#
#  bucket_name = local.loki_storage_name
#  is_public   = false
#}
