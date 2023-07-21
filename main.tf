module "ecr" {
  source      = "github.com/team-xquare/xquare-infrastructure-module.git//modules/ecr?ref=v0.0.4"

  for_each    = toset(local.stag_ecr_names)
  name        = each.key

  image_limit = local.stag_tag_limit
  tag_prefix  = local.stag_tag_prefix
}
