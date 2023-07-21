module "stag_ecr" {
  source      = "github.com/team-xquare/xquare-infrastructure-module.git//modules/ecr?ref=v0.0.4"

  for_each    = local.stag_ecr_names
  name        = each.key

  image_limit = local.stag_tag_limit
  tag_prefix  = local.stag_tag_prefix
}

module "prod_ecr" {
  source      = "github.com/team-xquare/xquare-infrastructure-module.git//modules/ecr?ref=v0.0.4"

  for_each    = local.prod_ecr_names
  name        = each.key

  image_limit = local.prod_tag_limit
  tag_prefix  = local.prod_tag_prefix
}

module "vpc" {
  source          = "github.com/team-xquare/xquare-infrastructure-module.git//modules/vpc?ref=v0.0.5"

  vpc_cidr        = local.vpc_cidr
  azs             = local.azs
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets
  name_prefix     = local.name_prefix
}

module "eks" {
  source          = "github.com/team-xquare/xquare-infrastructure-module.git//modules/eks-cluster?ref=v0.0.6"

  name_prefix     = local.name_prefix
  cluster_version = local.cluster_version
  instance_type   = local.node_type

  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnet_ids
  public_subnets  = module.vpc.public_subnet_ids
}
