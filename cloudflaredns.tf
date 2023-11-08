locals {
  a_recode_type             = "A"
  cname_recode_type         = "CNAME"
  xquare_design             = "design"
  xquare_mysql              = "mysql"
  xquare_redis              = "redis"
  xquare_cname_recode_names = [
    "admin",
    "argo-cd",
    "cloud-config",
    "dex-login",
    "dex",
    "grafana",
    "infisical",
    "jaeger",
    "keycloak",
    "kiali",
    "oidc-proxy",
    "prod-server",
    "project",
    "service",
    "stag-server",
    "thanos-store",
    "thanos",
  ]
  pick_cname_recode_names = [
    "admin",
    "teacher",
  ]
  repo_a_recode_names = [
    "admin",
    "mariadb",
    "mongodb",
    "server",
  ]
  repo_cname_recode_names = [
    "admin",
    "mariadb",
    "mongodb",
    "server",
    "api",
    "teacher",
    "test",
    "user",
    "www",
  ]
  repo_resume = "resume"
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
  email     = var.cloudflare_email
}

resource "cloudflare_record" "xquare_cname_record" {
  for_each = toset(local.xquare_cname_recode_names)
  name     = each.value
  proxied  = false
  ttl      = 1
  type     = local.cname_recode_type
  value    = var.xquare_cname_value
  zone_id  = var.xquare_cloudflare_zone_id
}

resource "cloudflare_record" "pick_cname_record" {
  for_each = toset(local.pick_cname_recode_names)
  name     = each.value
  proxied  = false
  ttl      = 1
  type     = local.cname_recode_type
  value    = var.xquare_cname_value
  zone_id  = var.pick_cloudflare_zone_id
}

resource "cloudflare_record" "repo_cname_record" {
  for_each = toset(local.repo_cname_recode_names)
  name     = each.value
  proxied  = false
  ttl      = 1
  type     = local.cname_recode_type
  value    = var.xquare_cname_value
  zone_id  = var.repo_cloudflare_zone_id
}

resource "cloudflare_record" "repo_a_record" {
  for_each = toset(local.repo_a_recode_names)
  name     = each.value
  proxied  = false
  ttl      = 1
  type     = local.a_recode_type
  value    = var.repo_a_value
  zone_id  = var.repo_cloudflare_zone_id
}

resource "cloudflare_record" "xquare_design" {
  name    = local.xquare_design
  proxied = false
  ttl     = 1
  type    = local.cname_recode_type
  value   = var.xquare_design
  zone_id = var.xquare_cloudflare_zone_id
}

resource "cloudflare_record" "xquare_mysql" {
  name    = local.xquare_mysql
  proxied = false
  ttl     = 1
  type    = local.cname_recode_type
  value   = var.xquare_mysql
  zone_id = var.xquare_cloudflare_zone_id
}

resource "cloudflare_record" "xquare_redis" {
  name    = local.xquare_redis
  proxied = false
  ttl     = 1
  type    = local.cname_recode_type
  value   = var.xquare_redis
  zone_id = var.xquare_cloudflare_zone_id
}

resource "cloudflare_record" "repo_resume" {
  name    = local.repo_resume
  proxied = false
  ttl     = 1
  type    = local.cname_recode_type
  value   = var.repo_resume
  zone_id = var.repo_cloudflare_zone_id
}