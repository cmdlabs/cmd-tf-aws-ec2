# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.5.0] 2020-08-19
### Breaking
- The tag hierarchy is now merged rather than replaced. This means you no longer need to define the same tag multiple times for it to be used on all resources.

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
