terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
    random = {
      source = "hashicorp/random"
    }
  }
  required_version = ">= 1.1.0"
}

cloud {
  organization = "smidd"
  workspaces {
    name = "learn-terraform-github-actions"
  }
}

variable "account_id" {
  type = string
}

variable "cloudflare_api_token" {
  type = string
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
