provider "aws" {
  version = "3.24.0"
  profile = "cmdlabtf-master"
  region  = "ap-southeast-2"
}

provider "tls" {
  version = "2.1.1"
}
