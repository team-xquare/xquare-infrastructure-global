module "stag_ecr" {
  source = "./modules/ecr"

  for_each = local.stag_ecr_names
  name     = each.value

  image_limit = local.stag_tag_limit
  tag_prefix  = local.stag_tag_prefix
}

module "prod_ecr" {
  source = "./modules/ecr"

  for_each = local.prod_ecr_names
  name     = each.value

  image_limit = local.prod_tag_limit
  tag_prefix  = local.prod_tag_prefix
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr        = local.vpc_cidr
  azs             = local.azs
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets
  name_prefix     = local.name_prefix
}

module "eks" {
  source = "./modules/eks-cluster"

  name_prefix     = local.name_prefix
  cluster_version = local.cluster_version
  instance_type   = local.node_type

  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnet_ids
  public_subnets  = module.vpc.public_subnet_ids

  create_cloudwatch_logs_group = false
}

module "sqs" {
  source = "./modules/sqs"

  name_prefix = local.name_prefix
  fifo_queue = local.fifo_queue
  content_based_deduplication = local.content_based_deduplication
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
