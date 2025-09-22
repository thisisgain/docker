# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.7.0]

### Included Tools
- AWS CLI: 2.30.3
- AWS CDK: 2.1029.1
- AWS Amplify: 14.0.0
- EB CLI: 3.25
- PHP: 8.4.12-fpm
- NVM: 0.39.7
  - Node: v20.18.1
  - NPM: 10.8.2
- Composer: 2.8.11
- Python3: 3.13.5
- Python2: 2.7.13
- Ansible: 2.19.2
- Acquia CLI: 2.48.0

### Added
- PHP 8.4-fpm (upgraded from 8.3-fpm)
- Python 2.7 support from Debian archive
- BCMath PHP extension
- Memory limit configuration (512M)
- Node.js version switching script

### Changed
- Base image updated to php:8.4-fpm
- Improved NVM integration with system profile
- Enhanced Node.js version management

### Fixed
- Node.js version switching functionality
- EB CLI python command not found error

## [1.6.1]

### Included Tools
- AWS CLI: 2.30.5
- AWS CDK: 2.1029.2
- AWS Amplify: 14.0.1
- EB CLI: 3.25
- PHP: 8.3.25-fpm
- NVM: 0.39.7
  - Node: v20.18.1
  - NPM: 10.8.2
- Composer: 2.8.11
- Python3: 3.13.5
- Python2: 2.7.13
- Ansible: 2.19.2
- Acquia CLI: 2.48.0

### Added
- Updated PHP 8.3-fpm
- Node.js version switching script

### Changed
- Improved NVM integration with system profile
- Enhanced Node.js version management

## [1.6.0] - Previous Release

### Included Tools
- AWS CLI: 2.30.3
- AWS CDK: 2.1029.1
- AWS Amplify: 14.0.0
- EB CLI: 3.25
- PHP: 8.4.12-fpm
- NVM: 0.39.7
  - Node: v20.18.1
  - NPM: 10.8.2
- Composer: 2.8.11
- Python3: 3.13.5
- Ansible: 2.19.2
- Acquia CLI: 2.48.0

### Features
- Multi-architecture support (linux/amd64, linux/arm64)
- Dynamic Node.js version switching via NODE_VERSION environment variable
- PHP extensions: GD, ZIP, BCMath
- Complete development toolchain for PHP, Node.js, and Python projects

---

## Usage

To use a specific version:
```bash
docker run --rm -ti thisisgain/toolbox:1.6.0 <command>
```

To use with custom Node.js version:
```bash
docker run --rm -ti -e NODE_VERSION=16 thisisgain/toolbox:1.6.0 node --version
```