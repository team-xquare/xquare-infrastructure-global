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

module "notification_queue" {
  source = "./modules/sqs"
  name = local.sqs_notification_queue_name
}

module "group_notification_queue" {
  source = "./modules/sqs"
  name = local.sqs_group_notification_queue_name
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

resource "aws_db_instance" "xquare-db" {
  identifier                = "${local.name_prefix}-db"
  allocated_storage         = local.db_storage_size
  engine                    = local.db_engine
  instance_class            = local.db_type
  availability_zone         = "${data.aws_region.current.name}c"
}
