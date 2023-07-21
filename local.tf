locals {
  name_prefix = "xquare"
  ecr_names = [
    "application-be",
    "attachment-be",
    "authority-be",
    "backoffice-be",
    "contour-middleware-be",
    "feed-be",
    "meal-be",
    "notification-be",
    "pick-be",
    "point-be",
    "report-be",
    "schedule-be",
    "timetable-be",
    "user-be",
    "apply-fe",
    "dormitory-admin-fe",
    "feed-fe",
    "school-meal-fe",
    "xbridge-test-fe",
  ]
}

locals {
  stag_ecr_names = {
    for name in local.ecr_names : name => "${name}-stag"
  }
  stag_tag_prefix = "stag-"
  stag_tag_limit  = 5

  prod_ecr_names  = {
    for name in local.ecr_names : name => "${name}-prod"
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
