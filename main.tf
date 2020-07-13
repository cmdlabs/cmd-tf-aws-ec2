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
*
* ## Additional EBS Volumes
* To attach additional EBS volumes the `ebs_block_devices` variable is used. It uses a custom object syntax which cannot be enforced by object() due to it having optional parameters.
*
* The following parameters are supported:
* - device_name (Required)
* - type (Optional)
* - size (Optional)
* - encrypted (Optional)
* - iops (Optional)
* - snapshot_id (Optional)
* - kms_key_id (Optional)
*
* ```hcl
* ebs_block_devices = [
*   {
*      device_name = "/dev/sdf"
*      type        = "gp2"
*      size        = 5
*      encrypted   = true
*    },
*    {
*      device_name = "/dev/sdg"
*      type        = "gp2"
*      size        = 10
*      encrypted   = true
*    }
* ]
* ```
*
* ## Tags
* There are 3 ways to manage tags with this module. This is primarily to allow the different use cases of AWS Backup.
*
* `tags` is used when you dont need to set specific backup tags on the instance/ebs volumes. It applies to all resources created by the module.
* `volume_tags` is use to override the tags set on ebs volumes. Useful if you are using AWS Backup with EBS snapshots
* `instance_tags` is used to override the tags set on the ec2 instance. Useful if you are using AWS Backup with EC2 AMI backups.
*
*/

resource "aws_instance" "main" {
  ami           = var.ami_id
  instance_type = var.instance_type

  associate_public_ip_address = var.create_eip || var.eip_allocation_id != "" ? true : var.associate_public_ip_address
  disable_api_termination     = var.enable_termination_protection
  ebs_optimized               = var.ebs_optimized
  iam_instance_profile        = var.create_iam_role || var.attached_iam_role_name != "" ? aws_iam_instance_profile.main[0].name : ""
  key_name                    = var.create_keypair ? aws_key_pair.keypair_public[0].key_name : var.keypair_name
  monitoring                  = var.enable_detailed_monitoring
  private_ip                  = var.private_ip
  subnet_id                   = var.subnet_id
  user_data                   = var.user_data
  vpc_security_group_ids      = var.create_security_group ? concat([aws_security_group.main[0].id], var.additional_security_group_ids) : var.additional_security_group_ids

  tags        = merge({ Name = var.instance_name }, var.instance_tags != {} ? var.instance_tags : var.tags)
  volume_tags = var.volume_tags != {} ? var.volume_tags : var.tags

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

  dynamic "network_interface" {
    for_each = var.network_interfaces
    content {
      device_index          = network_interface.value.device_index
      network_interface_id  = lookup(network_interface.value, "network_interface_id", null)
      delete_on_termination = lookup(network_interface.value, "delete_on_termination", false)
    }
  }
}

resource "aws_ebs_volume" "main" {
  count = length(var.ebs_block_devices)

  availability_zone = data.aws_subnet.current.availability_zone
  encrypted         = lookup(var.ebs_block_devices[count.index], "encrypted", true)
  iops              = lookup(var.ebs_block_devices[count.index], "iops", null)
  size              = lookup(var.ebs_block_devices[count.index], "size", null)
  snapshot_id       = lookup(var.ebs_block_devices[count.index], "snapshot_id", null)
  type              = lookup(var.ebs_block_devices[count.index], "type", null)
  kms_key_id        = lookup(var.ebs_block_devices[count.index], "kms_key_id", null)
  tags              = var.volume_tags != {} ? var.volume_tags : var.tags
}

resource "aws_volume_attachment" "main" {
  count = length(var.ebs_block_devices)

  device_name = var.ebs_block_devices[count.index]["device_name"]
  instance_id = aws_instance.main.id
  volume_id   = aws_ebs_volume.main[count.index].id
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
