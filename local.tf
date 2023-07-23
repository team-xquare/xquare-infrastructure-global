locals {
  name_prefix = "xquare"
  ecr_names = [
    # ECR_REPOSITORY_NAME
  ]
  region = "ap-northeast-2"
}

locals {
  stag_ecr_names = {
    for name in local.ecr_names :
    name => name if slice(name, -5, -1) == "-stag"
  }
  stag_tag_prefix = "stag-"
  stag_tag_limit  = 5

  prod_ecr_names  = {
    for name in local.ecr_names :
    name => name if slice(name, -5, -1) == "-prod"
  }
  prod_tag_prefix = "v"
  prod_tag_limit  = 5
}

locals {
  azs             = ["${data.aws_region.current.name}a", "${data.aws_region.current.name}c"]
  public_subnets  = ["10.0.0.0/20", "10.0.16.0/20"]
  private_subnets = ["10.0.128.0/20", "10.0.144.0/20"]
  vpc_cidr        = "10.0.0.0/16"
}

locals {
  cluster_version = "1.27"
  node_type       = "m5a.xlarge"
}
