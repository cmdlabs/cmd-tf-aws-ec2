# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.8.5] 2023-01-09
### Fixed
- push 0.8.5 Povide more output options including Private IP, Public IP (if any) and the instance data as a whole.

## [0.8.4] 2022-12-21
### Fixed
- push 0.8.4 tag

## [0.8.2] 2022-08-04
### Fixed
- version constraints was breaking usage with providers >= 4.x

## [0.8.1] 2022-07-09
### Changed
- private_ip when using providers >= 4.0.0  private_ip has to be null or IP CIDR

## [0.8.0] 2022-06-10
### Changed
- updated cmdlabs/terraform-utils to 8.4.0 (TF 0.14.6)
- updated flemay/envvars to 0.0.8
- updated aws provider minimum version to 3.75.0

## [0.7.0] 2021-09-21
### Changed
- `var.volume_tags` behaviour in underlying resources. At instance level, tags are now applied to `root_block_device` directly (rather than `aws_instance --> volume_tags`). This was to resolve behavioural issues of applying tags across multiple block devices, including root devices and secondary, such as when using provider `default_tags`. (See [here](https://github.com/hashicorp/terraform-provider-aws/issues/19188))
- Uplift required AWS provider version to *>= 3.24.0* to support above change.

## [0.6.0] 2020-11-17
### Added
- `var.metadata_options` to control IMDS configuration. Useful if you need to access the metadata endpoint from inside a docker container.

## [0.5.0] 2020-08-19
### Breaking
- The tag hierarchy is now merged rather than replaced. This means you no longer need to define the same tag multiple times for it to be used on all resources.
- Default IAM Role/Security Group names no longer have the `-main` suffix

### Added
- `var.enable_source_dest_check` to allow disabling the ec2 hypervisor from checking traffic is to this instance
- `var.create_instance_profile` to allow disabling the creation of an instance profile, if this is false you must ensure the role you are using already has an ec2 instance profile.
- `var.custom_iam_role_name` to allow changing the name of the created iam role
- `var.custom_instance_profile_name` to allow changing the name of the created instance_profile
- `var.custom_security_group_name` to allow changing the name of the created security group

### Fixed
- You can now rename an instance by just changing `var.instance_name`

## [0.4.0] 2020-07-13
### Added
- `var.ebs_optimized` to maintain compatability with instances created via the console. Defaults to false to maintain backwards compatability with previous versions.

## [0.3.0] 2020-07-09
### Added
- `var.instance_tags` so you can tag the ec2 instance with its own specific tags

## [0.2.0] 2020-07-07
### Breaking
- `var.additional_ebs_volumes` has slightly different parameters names due to the refactor to support expansion. See the README.md for more details.

### Changes
- `additional_ebs_volumes` now supports disk expansion.
- Instance profiles will no longer be created when no IAM role is created/attached.

## [0.1.0] 2020-07-02
### Added
- Initial Release
