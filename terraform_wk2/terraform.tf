# Provider Versioning

terraform {
  required_version = "~>1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.4.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
    }
  }
}