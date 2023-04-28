terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
    local = {
      source = "hashicorp/local"
    }
  }
  required_version = ">= 1.1.0"
}

variable "zone_id" {
  default = "14c60605fcfc8d89331d1c039fb92e5d"
}

variable "account_id" {
  default = "7e9918092d616256ce61ad41e0319dba"
}

variable "cloudflare_api_token" {
 type        = string
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
