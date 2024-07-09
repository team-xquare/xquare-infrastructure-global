provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

locals {
  a_record_type     = "A"
  cname_record_type = "CNAME"
  xquare_design_record_name = "design"
  xquare_mysql_record_name  = "mysql"
  xquare_redis_record_name  = "redis"
  xquare_server_record_names = [
    # DOMAIN_NAME
    "maeumgagym-docs",
    "rlaisqls",
    "rlaisqls",
    "rlaisqls",
    "rlaisqls",
    "rlaisqls",
    "rlaisqls",
    "rlaisqls",
    "rlaisqls",
    "rlaisqls",
    "auth",
    "entry-admission-admin-stag",
    "entry-admin-admission-stag",
    "entry-admission-stag",
    "equus",
    "photohub-stag",
    "photohub-stag",
    "photohub-backend-stag",
    "equus-feed-stag",
    "equus-stag",
    "propofol",
    "entry-auth-stag",
    "entry-auth",
    "entry-lts",
    "entry-lts-stag",
    "admin",
    "api-chitchat",
    "argo-cd",
    "aster",
    "cloud-config",
    "daedongyeojido-fe",
    "daedongyeojido_fe",
    "daedongyeojido",
    "dev-api.ddms-dsm.com",
    "dev-dms",
    "devlib",
    "dex-login",
    "dex",
    "dms",
    "dutyful-stag",
    "grafana",
    "infisical",
    "jaeger",
    "keycloak",
    "kht",
    "kiali",
    "kube-cost",
    "loki",
    "maeumgagym-admin-stag",
    "maeumgagym-hook",
    "maeumgagym-main-stag",
    "maeumgagym-user-stag",
    "maeumgagym",
    "merge-backend",
    "merge-user",
    "oidc-proxy",
    "pick-admin-stag",
    "pick-admin",
    "pick-stag",
    "pick-teacher-stag",
    "pick-teacher",
    "prod-server",
    "project",
    "prometheus",
    "scul",
    "service",
    "singtory-api",
    "stag-server",
    "thanos-store",
    "thanos",
    "tsdata.aliens-dms.com",
    "tsdata",
    "vault",
    "grafana-tempo",
    "gocd",
    "equus-stag-kafka"
  ]
  pick_server_record_names = [
    "admin",
    "teacher",
  ]
  repo_on_premise_record_names = [
    "admin",
    "mariadb",
    "mongodb",
    "server",
  ]
  repo_server_record_names = [
    "api",
    "teacher",
    "test",
    "user",
    "www",
  ]
}

resource "cloudflare_record" "xquare_server_record" {
  for_each = toset(local.xquare_server_record_names)
  name     = each.value
  proxied  = false
  ttl      = 1
  type     = local.cname_record_type
  value    = var.xquare_server_domain
  zone_id  = var.xquare_cloudflare_zone_id
}

resource "cloudflare_record" "pick_server_record" {
  for_each = toset(local.pick_server_record_names)
  name     = each.value
  proxied  = false
  ttl      = 1
  type     = local.cname_record_type
  value    = var.xquare_server_domain
  zone_id  = var.pick_cloudflare_zone_id
}

resource "cloudflare_record" "repo_server_record" {
  for_each = toset(local.repo_server_record_names)
  name     = each.value
  proxied  = false
  ttl      = 1
  type     = local.cname_record_type
  value    = var.xquare_server_domain
  zone_id  = var.repo_cloudflare_zone_id
}

resource "cloudflare_record" "repo_on_premise_record" {
  for_each = toset(local.repo_on_premise_record_names)
  name     = each.value
  proxied  = false
  ttl      = 1
  type     = local.a_record_type
  value    = var.repo_on_premise_ip
  zone_id  = var.repo_cloudflare_zone_id
}

resource "cloudflare_record" "xquare_design_record" {
  name    = local.xquare_design_record_name
  proxied = false
  ttl     = 1
  type    = local.cname_record_type
  value   = var.xquare_design_domain
  zone_id = var.xquare_cloudflare_zone_id
}

resource "cloudflare_record" "xquare_mysql_record" {
  name    = local.xquare_mysql_record_name
  proxied = false
  ttl     = 1
  type    = local.cname_record_type
  value   = var.xquare_mysql_domain
  zone_id = var.xquare_cloudflare_zone_id
}

resource "cloudflare_record" "xquare_redis_record" {
  name    = local.xquare_redis_record_name
  proxied = false
  ttl     = 1
  type    = local.cname_record_type
  value   = var.xquare_redis_domain
  zone_id = var.xquare_cloudflare_zone_id
}

