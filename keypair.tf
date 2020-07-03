resource "tls_private_key" "main" {
  count = var.create_keypair ? 1 : 0

  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_ssm_parameter" "keypair_private" {
  count = var.create_keypair ? 1 : 0

  name  = "/ec2-keypairs/${var.instance_name}"
  type  = "SecureString"
  value = tls_private_key.main[0].private_key_pem

  tags = var.tags
}

resource "aws_key_pair" "keypair_public" {
  count = var.create_keypair ? 1 : 0

  key_name   = var.instance_name
  public_key = tls_private_key.main[0].public_key_openssh

  tags = var.tags
}
