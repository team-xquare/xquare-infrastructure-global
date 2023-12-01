variable "rds_master_password" {
  type = string
  default = ""
}

variable "cloudflare_api_token" {
  type = string
  default = ""
}

variable "xquare_cloudflare_zone_id" {
  type = string
  default = ""
}

variable "pick_cloudflare_zone_id" {
  type = string
  default = ""
}

variable "repo_cloudflare_zone_id" {
  type = string
  default = ""
}

variable "xquare_server_domain" {
  type = string
  default = ""
}

variable "xquare_design_domain" {
  type = string
  default = ""
}

variable "xquare_mysql_domain" {
  type = string
  default = ""
}

variable "xquare_redis_domain" {
  type = string
  default = ""
}

variable "repo_on_premise_ip" {
  type = string
  default = ""
}
