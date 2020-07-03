provider "aws" {
  version                 = "2.68.0"
  profile                 = "cmdlabtf-master"
  region                  = "ap-southeast-2"
  skip_metadata_api_check = true
}

provider "tls" {
  version = "2.1.1"
}
