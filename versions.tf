terraform {
  required_version = ">= 0.12.31"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.75.1"
    }

    tls = {
      source  = "hashicorp/tls"
      version = ">= 3.4.0"
    }
  }
}
