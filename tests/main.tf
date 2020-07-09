# Test Dependencies
module "vpc" {
  source = "github.com/cmdlabs/cmd-tf-aws-vpc?ref=0.9.0"

  vpc_name                  = "ec2-ci-test"
  vpc_cidr_block            = "10.0.0.0/16"
  availability_zones        = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]
  enable_per_az_nat_gateway = false
}

resource "aws_security_group" "test_sg" {
  name   = "ec2-ci-test-sg"
  vpc_id = module.vpc.vpc_id
}

resource "aws_iam_role" "ci_test" {
  name               = "ec2-ci-test"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_sns_topic" "ci_test" {
  name = "ec2-ci-test"
}

# Test1 - EC2 Instance with security group creation. Also tests both ingress_security_group_rule object types. Tests attaching additional security groups.
module "ec2_with_sg_creation" {
  source = "../"

  instance_name = "ec2-ci-test-with-sg"
  ami_id        = "ami-088ff0e3bde7b3fdf"
  instance_type = "t3.micro"
  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.private_tier_subnet_ids[0]

  root_block_device = {
    volume_type = "gp2"
    volume_size = 10
    encrypted   = true
  }

  additional_security_group_ids = [aws_security_group.test_sg.id]

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
      source_security_group_id = aws_security_group.test_sg.id
    }
  ]

  tags = {
    Foo = "Bar"
  }
}

# Test2 - EC2 instance with an externally managed security group
module "ec2_without_sg_creation" {
  source = "../"

  instance_name                 = "ec2-ci-test-without-sg"
  ami_id                        = "ami-088ff0e3bde7b3fdf"
  instance_type                 = "t3.micro"
  vpc_id                        = module.vpc.vpc_id
  subnet_id                     = module.vpc.private_tier_subnet_ids[0]
  create_security_group         = false
  additional_security_group_ids = [aws_security_group.test_sg.id]

  volume_tags = {
    VolTag = "Test"
  }

  instance_tags = {
    InstTag = "Test"
  }
}

# Test3 - EC2 instance with iam role creation. Tests inline policy as well as existing policy attachment
module "ec2_with_iam_creation" {
  source = "../"

  instance_name = "ec2-ci-test-with-iam"
  ami_id        = "ami-088ff0e3bde7b3fdf"
  instance_type = "t3.micro"
  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.private_tier_subnet_ids[0]

  create_iam_role = true
  iam_policy = [
    {
      actions   = ["s3:ListBucket"]
      resources = ["*"]
    },
    {
      actions   = ["s3:HeadBucket"]
      resources = ["*"]
    }
  ]
  iam_policy_attachment = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
}

# Test4 - EC2 instance with iam role creation. Tests with only attachment
module "ec2_with_iam_creation_attachment" {
  source = "../"

  instance_name = "ec2-ci-test-with-iam-attachment"
  ami_id        = "ami-088ff0e3bde7b3fdf"
  instance_type = "t3.micro"
  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.private_tier_subnet_ids[0]

  create_iam_role       = true
  iam_policy_attachment = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
}

# Test5 - EC2 instance with iam role creation. Tests with only inline
module "ec2_with_iam_creation_inline" {
  source = "../"

  instance_name = "ec2-ci-test-with-iam-inline"
  ami_id        = "ami-088ff0e3bde7b3fdf"
  instance_type = "t3.micro"
  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.private_tier_subnet_ids[0]

  create_iam_role = true

  iam_policy = [
    {
      actions   = ["s3:ListBucket"]
      resources = ["*"]
    },
    {
      actions   = ["s3:HeadBucket"]
      resources = ["*"]
    }
  ]
}


# Test6 - EC2 instance with an externally managed iam role, additional ebs volume and sns topic for cloudwatch alarms
module "ec2_without_iam_creation" {
  source = "../"

  instance_name = "ec2-ci-test-with-external-iam"
  ami_id        = "ami-088ff0e3bde7b3fdf"
  instance_type = "t3.micro"
  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.private_tier_subnet_ids[0]

  attached_iam_role_name = aws_iam_role.ci_test.name

  cloudwatch_sns_topic_arn = aws_sns_topic.ci_test.arn

  ebs_block_devices = [
    {
      device_name = "/dev/sdf"
      type        = "gp2"
      size        = 5
      encrypted   = true
    },
    {
      device_name = "/dev/sdg"
      type        = "gp2"
      size        = 10
      encrypted   = true
    }
  ]
}

# Test7 - EC2 instance in a public subnet with an EIP and created key_pair
module "ec2_with_eip" {
  source = "../"

  instance_name = "ec2-ci-test-with-eip"
  ami_id        = "ami-088ff0e3bde7b3fdf"
  instance_type = "t3.micro"
  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.public_tier_subnet_ids[0]

  create_eip     = true
  create_keypair = true

  root_block_device = {
    volume_type = "gp2"
    volume_size = 10
    encrypted   = true
  }

  ingress_security_group_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}
