terraform {
  required_version = "~> 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.46"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
  cloud {
    hostname     = "app.terraform.io"
    organization = "xquare"
    workspaces {
      name = "xquare-global"
    }
  }
}

provider "aws" {
  region = local.region
}