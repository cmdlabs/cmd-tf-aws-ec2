# cmd-tf-aws-ec2
## Summary  
This module is used to build pet EC2 instances. It currently supports the following features:
- EC2 instance creation
- Create/Attach a Security Group
- Create/Attach an IAM Role (Only simple Action/Resource based policies are supported by Create. If you need more advanced features like Conditions you can create the role externally and attach it to the instance)
- Create/Attach an Elastic IP
- Create/Attach an EC2 KeyPair (Private Key is stored in SSM)
- AutoRecovery Cloudwatch Alarms with SNS support
- Tags

## Requirements

The following requirements are needed by this module:

- terraform (>= 0.12.6)

- aws (>= 2.68.0)

## Providers

The following providers are used by this module:

- aws (>= 2.68.0)

- tls

## Required Inputs

The following input variables are required:

### ami\_id

Description: EC2 ami id to create the instance from

Type: `string`

### instance\_name

Description: EC2 instance name

Type: `string`

### subnet\_id

Description: Subnet ID to deploy the instance to

Type: `string`

### vpc\_id

Description: VPC ID to deploy the instance to

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### additional\_security\_group\_ids

Description: List of additional security groups to attach to the EC2 instance

Type: `list(string)`

Default: `[]`

### associate\_public\_ip\_address

Description: Associate a public ip address with the instance

Type: `bool`

Default: `false`

### attached\_iam\_role\_name

Description: Existing IAM role name to attach. Ensure you set create\_iam\_role to false if you are using this.

Type: `string`

Default: `""`

### cloudwatch\_sns\_topic\_arn

Description: ARN of the SNS topic that will recieve Cloudwatch alarm notifications

Type: `string`

Default: `""`

### create\_eip

Description: Create an Elastic IP for the instance. If you want to attach an existing EIP use eip\_allocation\_id instead.

Type: `bool`

Default: `false`

### create\_iam\_role

Description: Create an IAM role and attach it to the instance

Type: `bool`

Default: `false`

### create\_keypair

Description: Create an EC2 keypair for the instance. The private key will be uploaded to SSM Parameter Store as an SecureString. Be aware that using this option will result in the private key being stored in the Terraform statefile which may not be appropriate in all organisations.

Type: `bool`

Default: `false`

### create\_security\_group

Description: Create a security group with the instance and apply the rules from ingress/egress\_security\_group\_rules

Type: `bool`

Default: `true`

### ebs\_block\_devices

Description: Additional EBS block device configuration. See https://www.terraform.io/docs/providers/aws/r/instance.html#block-devices

Type: `list(map(string))`

Default: `[]`

### egress\_security\_group\_rules

Description: List of maps of egress aws\_security\_group\_rules(excluding type) to attach to the created security group. See https://www.terraform.io/docs/providers/aws/r/security_group_rule.html

Type: `any`

Default:

```json
[
  {
    "cidr_blocks": [
      "0.0.0.0/0"
    ],
    "from_port": 0,
    "protocol": "-1",
    "to_port": 0
  }
]
```

### eip\_allocation\_id

Description: Allocation ID for an existing EIP

Type: `string`

Default: `""`

### enable\_detailed\_monitoring

Description: Enable EC2 detailed monitoring. Additional costs apply

Type: `bool`

Default: `false`

### enable\_ec2\_autorecovery

Description: Automatically create Cloudwatch alarms that will recover/reboot the instnace on status check failure

Type: `bool`

Default: `true`

### enable\_termination\_protection

Description: Enable termination protection to prevent the EC2 instance from being destroyed

Type: `bool`

Default: `false`

### iam\_policy

Description: List of iam statements to attach to the created IAM role

Type: `any`

Default: `[]`

### iam\_policy\_attachment

Description: List of existing iam policies to attach to the created IAM role

Type: `list(string)`

Default: `[]`

### ingress\_security\_group\_rules

Description: List of maps of ingress aws\_security\_group\_rule(excluding type) to attach to the created security group. See https://www.terraform.io/docs/providers/aws/r/security_group_rule.html

Type: `any`

Default: `[]`

### instance\_type

Description: EC2 instance type to use

Type: `string`

Default: `"t3.medium"`

### keypair\_name

Description: The name of an existing keypair

Type: `string`

Default: `""`

### network\_interfaces

Description: Custom network interface configuration. See https://www.terraform.io/docs/providers/aws/r/instance.html#network-interfaces

Type: `list(map(string))`

Default: `[]`

### private\_ip

Description: Specify the IP of the private interface rather than relying on DHCP

Type: `string`

Default: `""`

### root\_block\_device

Description: Root block device configuration. See https://www.terraform.io/docs/providers/aws/r/instance.html#block-devices

Type: `map(string)`

Default: `{}`

### tags

Description: Map of tags to apply to all created resources

Type: `map(string)`

Default: `{}`

### user\_data

Description: Userdata for the EC2 instance to run on startup

Type: `string`

Default: `""`

## Outputs

The following outputs are exported:

### instance\_id

Description: n/a

