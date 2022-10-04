module "ec2_instance" {
  source = "github.com/cmdlabs/cmd-tf-aws-ec2?ref=0.8.2"

  instance_name = "instance-1"
  ami_id        = "ami-088ff0e3bde7b3fdf"
  instance_type = "t3.micro"
  vpc_id        = "vpc-03f0cfcb8b94a898a"
  subnet_id     = "subnet-0d375f7f06d795235"

  root_block_device = {
    volume_type = "gp3"
    volume_size = 10
    encrypted   = true
  }

  ebs_block_devices = [
    {
      device_name = "/dev/sdf"
      volume_type = "gp3"
      volume_size = 5
      encrypted   = true
    }
  ]

  ingress_security_group_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port                = 22
      to_port                  = 22
      protocol                 = "tcp"
      source_security_group_id = "sg-033220b3c4250d744"
    }
  ]

  create_iam_role = true
  iam_policy = [
    {
      actions   = ["s3:ListBucket"]
      resources = ["*"]
    }
  ]
  iam_policy_attachment = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]

  tags = {
    Repository = ""
    Workspace  = ""
  }
}
