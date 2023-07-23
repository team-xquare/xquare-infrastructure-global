locals {
  name_prefix = "xquare"
  ecr_names = [
    # ECR_REPOSITORY_NAME
    "user-be-stag",
    "point-be-stag",
    "meal-be-stag",
    "feed-be-prod",
    "attachment-be-stag",
    "application-be-prod",
    "application-be-stag",
  ]
  region = "ap-northeast-2"
}

locals {
  stag_ecr_names  = toset([
    for name in local.ecr_names : name if endswith(name, "-stag")
  ])
  stag_tag_prefix = "stag-"
  stag_tag_limit  = 5

  prod_ecr_names  = toset([
    for name in local.ecr_names : name if endswith(name, "-prod")
  ])
  prod_tag_prefix = "prod-"
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
