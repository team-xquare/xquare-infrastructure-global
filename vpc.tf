locals {
  azs             = ["${data.aws_region.current.name}a", "${data.aws_region.current.name}c"]
  public_subnets  = ["10.0.0.0/20", "10.0.16.0/20"]
  private_subnets = ["10.0.128.0/20", "10.0.144.0/20"]
  vpc_cidr        = "10.0.0.0/16"
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr        = local.vpc_cidr
  azs             = local.azs
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets
  public_subnet_tags_per_az = {
    "${local.region}a" = {
      "karpenter.sh/discovery/xquare-v3-cluster" = "xquare-v3-cluster"
      "kubernetes.io/cluster/xquare-v3-cluster"  = "owned"
      "kubernetes.io/role/elb"                   = "1"
    },
    "${local.region}c" = {
      "karpenter.sh/discovery/xquare-v3-cluster" = "xquare-v3-cluster"
      "kubernetes.io/cluster/xquare-v3-cluster"  = "owned"
      "kubernetes.io/role/elb"                   = "1"
    }
  }

  name_prefix  = local.name_prefix
  cluster_name = "${local.name_prefix_v3}-cluster"
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = module.vpc.vpc_id
  service_name = "com.amazonaws.ap-northeast-2.s3"
}
