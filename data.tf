data "aws_region" "current" {}

data "aws_subnet" "current" {
  id = var.subnet_id
}
