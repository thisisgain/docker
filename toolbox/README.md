# docker-toolbox

Basic image to use for builds.

This image is based on php 8.3-fpm

## Features

Set of tools to run for building several kind of projects.

Tools in this image:
* aws cli: 2.27.32
* aws cdk: 2.1018.0
* aws amplify: 13.0.1
* eb: 3.24.1
* php: 8.3.22-fpm
* nvm: 0.39.7
  * node: v20.18.1
  * npm: 10.8.2
* composer: 2.8.9
* python3: 3.11.2
* ansible: 2.18.6
* acli: 2.42.0

## NVM

Node is set up via nvm. The version above is the default version. If a different version is required, you can set an environment variable "NODE_VERSION" with the specific node version required for run of the container.

Example: `docker run --rm -ti -e NODE_VERSION=16 thisisgain/toolbox:1.6.0 node --version`
