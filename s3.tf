locals {
  prod_storage_name   = "xquare-prod-bucket"
  stag_storage_name   = "xquare-stag-bucket"
  thanos_storage_name = "xquare-thanos"
  loki_storage_name   = "xquare-loki"
  tempo_storage_name   = "xquare-tempo"
  cache_storage_name = "xquare-cache"
}

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

module "thanos_storage" {
  source = "./modules/s3"

  bucket_name = local.thanos_storage_name
  is_public   = false
}

module "loki_storage" {
  source = "./modules/s3"

  bucket_name = local.loki_storage_name
  is_public   = false
}

module "tempo_storage" {
  source = "./modules/s3"

  bucket_name = local.tempo_storage_name
  is_public   = false
}

module "cache_storage" {
  source = "./modules/s3"

  bucket_name = local.cache_storage_name
  is_public = false
}
