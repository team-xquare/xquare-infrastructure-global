locals {
  name_prefix = "xquare"
}

locals {
  stag_ecr_names = [
    "application-be-stag",
    "attachment-be-stag",
    "authority-be-stag",
    "backoffice-be-stag",
    "contour-middleware-be-stag",
    "feed-be-stag",
    "meal-be-stag",
    "notification-be-stag",
    "pick-be-stag",
    "point-be-stag",
    "report-be-stag",
    "schedule-be-stag",
    "timetable-be-stag",
    "user-be-stag"]
  stag_tag_prefix = "stag-"
  stag_tag_limit  = 5
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
