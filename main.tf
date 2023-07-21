module "ecr" {
  source      = "github.com/team-xquare/xquare-infrastructure-module.git//modules/ecr?ref=v0.0.4"

  for_each    = var.stag_ecr
  name        = each.key

  image_limit = each.value.image_limit
  tag_prefix  = each.value.tag_prefix
}
