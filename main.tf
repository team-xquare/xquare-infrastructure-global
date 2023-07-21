module "ecr" {
  source      = "github.com/team-xquare/xquare-infrastructure-module.git//modules/ecr?ref=v0.0.4"

  for_each    = var.stag_ecr
  name        = each.key

  image_limit = var.stag_ecr.image_limit
  tag_prefix  = var.stag_ecr.tag_prefix
}
