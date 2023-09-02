locals {
  cluster_name     = "${var.name_prefix}-cluster"
  cluster_version  = var.cluster_version
  region           = "ap-northeast-2"
  vpc_id           = var.vpc_id
  public_subnets   = var.public_subnets
  private_subnets  = var.private_subnets
  current_username = element(split("/", data.aws_caller_identity.current.arn), 1)
  instance_type    = ["m5a.large", "m5a.xlarge"]
  capacity_type    = ["ON_DEMAND", "SPOT"]
  role_policy      = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
}
