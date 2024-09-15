module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 4.0"

  name = "${var.name_prefix}-vpc"
  cidr = var.vpc_cidr
  azs  = var.azs

  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  public_subnet_tags_per_az = var.public_subnet_tags_per_az

  enable_nat_gateway     = false
  single_nat_gateway     = false
  one_nat_gateway_per_az = false

  nat_gateway_tags = {
    Name = "${var.name_prefix}-nat"
  }

  igw_tags = {
    Name = "${var.name_prefix}-igw"
  }
  map_public_ip_on_launch = true
}

resource "aws_route" "private_to_igw" {
  for_each = toset(module.vpc.private_route_table_ids)

  route_table_id = each.key
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = module.vpc.igw_id
}