provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

locals {
  a_record_type     = "A"
  cname_record_type = "CNAME"

  xquare_design_record_name  = "design"
  xquare_mysql_record_name   = "mysql"
  xquare_redis_record_name   = "redis"
  xquare_server_record_names = [
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