variable "instance_name" {
  type        = string
  description = "EC2 instance name"
}

variable "ami_id" {
  type        = string
  description = "EC2 ami id to create the instance from"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type to use"
  default     = "t3.medium"
}

variable "enable_termination_protection" {
  type        = bool
  description = "Enable termination protection to prevent the EC2 instance from being destroyed"
  default     = false
}

variable "keypair_name" {
  type        = string
  description = "The name of an existing keypair"
  default     = ""
}

variable "enable_detailed_monitoring" {
  type        = bool
  description = "Enable EC2 detailed monitoring. Additional costs apply"
  default     = false
}

variable "additional_security_group_ids" {
  type        = list(string)
  description = "List of additional security groups to attach to the EC2 instance"
  default     = []
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID to deploy the instance to"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID to deploy the instance to"
}

variable "associate_public_ip_address" {
  type        = bool
  description = "Associate a public ip address with the instance"
  default     = false
}

variable "private_ip" {
  type        = string
  description = "Specify the IP of the private interface rather than relying on DHCP"
  default     = ""
}

variable "user_data" {
  type        = string
  description = "Userdata for the EC2 instance to run on startup"
  default     = ""
}

variable "tags" {
  type        = map(string)
  description = "Map of tags to apply to all created resources"
  default     = {}
}

variable "volume_tags" {
  type        = map(string)
  description = "Map of tags to apply to ebs volumes"
  default     = {}
}

variable "root_block_device" {
  type        = map(string)
  description = "Root block device configuration. See https://www.terraform.io/docs/providers/aws/r/instance.html#block-devices"
  default     = {}
}

variable "ebs_block_devices" {
  type        = list(map(string))
  description = "Additional EBS block device configuration. See https://www.terraform.io/docs/providers/aws/r/instance.html#block-devices"
  default     = []
}

variable "network_interfaces" {
  type        = list(map(string))
  description = "Custom network interface configuration. See https://www.terraform.io/docs/providers/aws/r/instance.html#network-interfaces"
  default     = []
}

variable "enable_ec2_autorecovery" {
  type        = bool
  description = "Automatically create Cloudwatch alarms that will recover/reboot the instnace on status check failure"
  default     = true
}

variable "cloudwatch_sns_topic_arn" {
  type        = string
  description = "ARN of the SNS topic that will recieve Cloudwatch alarm notifications"
  default     = ""
}

variable "create_security_group" {
  type        = bool
  description = "Create a security group with the instance and apply the rules from ingress/egress_security_group_rules"
  default     = true
}

variable "ingress_security_group_rules" {
  type        = any
  description = "List of maps of ingress aws_security_group_rule(excluding type) to attach to the created security group. See https://www.terraform.io/docs/providers/aws/r/security_group_rule.html"
  default     = []
}

variable "egress_security_group_rules" {
  type        = any
  description = "List of maps of egress aws_security_group_rules(excluding type) to attach to the created security group. See https://www.terraform.io/docs/providers/aws/r/security_group_rule.html"
  default = [{
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }]
}

variable "create_iam_role" {
  type        = bool
  description = "Create an IAM role and attach it to the instance"
  default     = false
}

variable "iam_policy" {
  type        = any
  description = "List of iam statements to attach to the created IAM role"
  default     = []
}

variable "iam_policy_attachment" {
  type        = list(string)
  description = "List of existing iam policies to attach to the created IAM role"
  default     = []
}

variable "attached_iam_role_name" {
  type        = string
  description = "Existing IAM role name to attach. Ensure you set create_iam_role to false if you are using this."
  default     = ""
}

variable "create_eip" {
  type        = bool
  description = "Create an Elastic IP for the instance. If you want to attach an existing EIP use eip_allocation_id instead."
  default     = false
}

variable "eip_allocation_id" {
  type        = string
  description = "Allocation ID for an existing EIP"
  default     = ""
}

variable "create_keypair" {
  type        = bool
  description = "Create an EC2 keypair for the instance. The private key will be uploaded to SSM Parameter Store as an SecureString. Be aware that using this option will result in the private key being stored in the Terraform statefile which may not be appropriate in all organisations."
  default     = false
}
