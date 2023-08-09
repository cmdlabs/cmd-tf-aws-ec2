terraform {
  required_version = "~> 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.76.1"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 3.4.0"
    }
  }
}

provider "aws" {
  profile = "cmdlabtf-master"
  region  = "ap-southeast-2"
}
