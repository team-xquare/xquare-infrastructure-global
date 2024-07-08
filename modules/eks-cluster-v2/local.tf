locals {
  cluster_name     = "${var.name_prefix}-cluster"
  cluster_version  = var.cluster_version
  region           = "ap-northeast-2"
  vpc_id           = var.vpc_id
  public_subnets   = var.public_subnets
  current_username = element(split("/", data.aws_caller_identity.current.arn), 1)
  instance_type    = var.instance_type
  capacity_type    = var.capacity_type
  az_subnets = [
      for id, subnet in data.aws_subnet.public :
      id
      if subnet.availability_zone == "${local.region}a"
  ]
}
