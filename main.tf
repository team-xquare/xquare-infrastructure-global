module "ecr" {
  source = "github.com/team-xquare/xquare-infrastructure-module.git//modules/ecr?ref=v0.0.2"
  name   = "test"
  prod_image_limit = 3
  prod_tag_prefix = "-prod"
  stag_image_limit = 3
  stag_tag_prefix = "-stag"
}
