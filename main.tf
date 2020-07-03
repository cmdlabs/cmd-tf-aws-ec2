/**
* # cmd-tf-aws-ec2
* ## Summary
* This module is used to build pet EC2 instances. It currently supports the following features:
* - EC2 instance creation
* - Create/Attach a Security Group
* - Create/Attach an IAM Role (Only simple Action/Resource based policies are supported by Create. If you need more advanced features like Conditions you can create the role externally and attach it to the instance)
* - Create/Attach an Elastic IP
* - Create/Attach an EC2 KeyPair (Private Key is stored in SSM)
* - AutoRecovery Cloudwatch Alarms with SNS support
* - Tags
*/

resource "aws_instance" "main" {
  ami           = var.ami_id
  instance_type = var.instance_type

  associate_public_ip_address = var.create_eip || var.eip_allocation_id != "" ? true : var.associate_public_ip_address
  disable_api_termination     = var.enable_termination_protection
  iam_instance_profile        = var.create_iam_role || var.attached_iam_role_name != "" ? aws_iam_instance_profile.main[0].name : ""
  key_name                    = var.create_keypair ? aws_key_pair.keypair_public[0].key_name : var.keypair_name
  monitoring                  = var.enable_detailed_monitoring
  private_ip                  = var.private_ip
  subnet_id                   = var.subnet_id
  user_data                   = var.user_data
  vpc_security_group_ids      = var.create_security_group ? concat([aws_security_group.main[0].id], var.additional_security_group_ids) : var.additional_security_group_ids

  tags        = merge({ Name = var.instance_name }, var.tags)
  volume_tags = merge({ Name = var.instance_name }, var.tags)

  dynamic "root_block_device" {
    for_each = var.root_block_device != {} ? [1] : []
    content {
      delete_on_termination = lookup(var.root_block_device, "delete_on_termination", null)
      encrypted             = lookup(var.root_block_device, "encrypted", true)
      iops                  = lookup(var.root_block_device, "iops", null)
      kms_key_id            = lookup(var.root_block_device, "kms_key_id", null)
      volume_size           = lookup(var.root_block_device, "volume_size", null)
      volume_type           = lookup(var.root_block_device, "volume_type", null)
    }
  }

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_devices
    content {
      device_name           = ebs_block_device.value.device_name
      delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", null)
      encrypted             = lookup(ebs_block_device.value, "encrypted", true)
      iops                  = lookup(ebs_block_device.value, "iops", null)
      kms_key_id            = lookup(ebs_block_device.value, "kms_key_id", null)
      snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
      volume_size           = lookup(ebs_block_device.value, "volume_size", null)
      volume_type           = lookup(ebs_block_device.value, "volume_type", null)
    }
  }

  dynamic "network_interface" {
    for_each = var.network_interfaces
    content {
      device_index          = network_interface.value.device_index
      network_interface_id  = lookup(network_interface.value, "network_interface_id", null)
      delete_on_termination = lookup(network_interface.value, "delete_on_termination", false)
    }
  }
}

resource "aws_eip" "main" {
  count = var.create_eip ? 1 : 0

  vpc      = true
  instance = aws_instance.main.id

  tags = merge({ Name = var.instance_name }, var.tags)
}

resource "aws_eip_association" "main" {
  count = var.create_eip == false && var.eip_allocation_id != "" ? 1 : 0

  allocation_id = var.eip_allocation_id
  instance_id   = aws_instance.main.id
}
