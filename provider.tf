terraform {
  required_version = "~> 1.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.38"
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