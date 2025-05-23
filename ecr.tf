locals {
  name_prefix    = "xquare"
  name_prefix_v2 = "xquare-v2"
  name_prefix_v3 = "xquare-v3"
  ecr_names = [
    # ECR_REPOSITORY_NAME
    "nuneddine-be-prod",
    "trader-be-prod",
    "trading-helper-be-prod",
    "sillok-fe-fe-prod",
    "eeats-be-prod",
    "equus-user-be-prod",
    "whopper-be-prod",
    "founderz-be-prod",
    "hackton-jeong-be-prod",
    "equus-application-be-prod",
    "testtest-be-stag",
    "repo-user-fe-prod",
    "repo-admin-fe-prod",
    "repo-main-fe-prod",
    "pick-teacher-fe-prod",
    "pick-admin-fe-prod",
    "envoy-middlware-be-prod",
    "scul-main-fe-prod",
    "xquare-infra-be-prod",
    "xquare-infra-fe-fe-prod",
    "kht-be-prod",
    "pick-admin-fe-stag",
    "pick-teacher-fe-stag",
    "pick-core-be-prod",
    "pick-core-be-stag",
    "scul-be-prod",
    "appjam-singtory-be-prod",
    "appjam-be-prod",
    "suno-api-be-prod",
    "pick-web-teacher-fe-prod",
    "new-pick-be-stag",
    "xquare-infra-frontend-fe-prod",
    "daedongyeojido-fe-fe-prod",
    "xquare-infra-backend-be-prod",
    "pick-web-admin-fe-prod",
    "dsm-login-be-prod",
    "xquare-infra-fe-prod",
    "dsm-ouath-be-prod",
    "xquare-event-listener-prod",
    "xquare-backoffice-be-prod",
    "nudia-be-prod",
    "maeumgagym-admin-fe-stag",
    "merge-backend-be-prod",
    "merge-user-fe-prod",
    "maeumgagym-user-fe-stag",
    "new-pick-be-prod",
    "daedongyeojido-fe-prod",
    "dashboard-tsdata-bridge-be-prod",
    "test-deploy-be-stag",
    "maeumgagym-be-prod",
    "dms-be-stag",
    "daedong-be-prod",
    "dms-be-prod",
    "afterschool-be-stag",
    "maeumgagym-frontend-fe-stag",
    "juso-be-prod",
    "test-be-prod",
    "maeumgagym-be-stag",
    "dutiful-be-stag",
    "aster-frontend-fe-prod",
    "svap-be-stag",
    "svap-be-prod",
    "aster-be-stag",
    "aster-be-prod",
    "entry-config-server-be-stag",
    "project-manager-front-fe-prod",
    "mukgen-be-stag",
    "xbridge-test-fe-prod",
    "repo-be-prod",
    "point-be-prod",
    "dormitory-admin-fe-prod",
    "authority-be-prod",
    "user-be-prod",
    "feed-be-stag",
    "project-secret-manager-be-prod",
    "pick-be-prod",
    "timetable-be-prod",
    "schedule-be-prod",
    "git-be-prod",
    "envoy-middleware-be-prod",
    "apply-fe-prod",
    "feed-fe-prod",
    "school-meal-fe-prod",
    "oauth-be-prod",
    "cloud-config-be-prod",
    "pick-be-stag",
    "meal-be-prod",
    "git-be-stag",
    "notification-be-stag",
    "report-be-stag",
    "schedule-be-stag",
    "authority-be-stag",
    "timetable-be-stag",
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
  stag_ecr_names = toset([
    for name in local.ecr_names : name if endswith(name, "-stag")
  ])
  stag_tag_prefix = "stag-"
  stag_tag_limit  = 5

  prod_ecr_names = toset([
    for name in local.ecr_names : name if endswith(name, "-prod")
  ])
  prod_tag_prefix = "prod-"
  prod_tag_limit  = 5
}

module "stag_ecr" {
  source = "./modules/ecr"

  for_each = local.stag_ecr_names
  name     = each.value

  image_limit = local.stag_tag_limit
  tag_prefix  = local.stag_tag_prefix
}

module "prod_ecr" {
  source = "./modules/ecr"

  for_each = local.prod_ecr_names
  name     = each.value

  image_limit = local.prod_tag_limit
  tag_prefix  = local.prod_tag_prefix
}

output "stag_ecr_url" {
  value = [
    for v in module.stag_ecr : v.ecr_repository_url
  ]
}

output "prod_ecr_url" {
  value = [
    for v in module.prod_ecr : v.ecr_repository_url
  ]
}
