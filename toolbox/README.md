# docker-toolbox

Basic image to use for builds.

This image is based on php 8.4-fpm

## Features

Set of tools to run for building several kind of projects.

Tools in this image:
* aws cli: 2.34.1
* aws cdk: 2.1109.0
* aws amplify: 14.2.5
* eb: 3.26
* php: 8.4.18-fpm
* nvm: 0.39.7
  * node: v20.18.1
  * npm: 10.8.2
* composer: 2.9.5
* python3: 3.13.5
* ansible: 2.20.3
* acli: 2.59.0

## NVM

Node is set up via nvm. The version above is the default version. If a different version is required, you can set an environment variable "NODE_VERSION" with the specific node version required for run of the container.

Example: `docker run --rm -ti -e NODE_VERSION=16 thisisgain/toolbox:1.7.0 node --version`

## Version History

For detailed version history and changes, see [CHANGELOG.md](https://github.com/thisisgain/docker-toolbox/blob/main/toolbox/CHANGELOG.md).

## Updating the image

Once the image has been updated, please update the CHANGELOG.md with your changes, and add the "### Included Tools" section into the new tag. After that, you can run the update-versions script following the `--help`, and will update the README.md and the CHANGELOG.md with the latest versions installed.