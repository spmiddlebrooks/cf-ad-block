terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 3.29.0"
    }
    local = {
      source = "hashicorp/local"
    }
  }
  required_version = ">= 1.1.0"
}

proivder "cloudflare" {
  api_token = ${{ secrets.CLOUDFLARE_API_TOKEN }}
}

variable "cloudflare_api_token" {
 type        = string
 default     = "${{ secrets.CLOUDFLARE_API_TOKEN }}"
}
