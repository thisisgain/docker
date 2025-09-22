#!/bin/bash

# Script to update tool versions in README.md and CHANGELOG.md
# Usage: docker run --rm -v $(pwd):/workspace -w /workspace toolbox:1.7.0 /workspace/update-versions.sh [VERSION]

README_FILE="README.md"
CHANGELOG_FILE="CHANGELOG.md"
VERSION_FILE="version.txt"

# Check if version.txt exists
if [ ! -f "$VERSION_FILE" ]; then
    echo "Error: Please create a version.txt with the current version before running this script."
    exit 1
fi

# Read current version from version.txt file
CURRENT_VERSION=$(cat "$VERSION_FILE")

# Check for help flag
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Usage examples:"
    echo "docker run --rm -v \$(pwd):/workspace -w /workspace thisisgain/toolbox:1.7.0 ./update-versions.sh"
    echo "docker run --rm -v \$(pwd):/workspace -w /workspace thisisgain/toolbox:1.7.0 ./update-versions.sh 1.8.0"
    exit 0
fi

# Use parameter if provided, otherwise use current version
VERSION=${1:-$CURRENT_VERSION}

echo "Updating versions for release: $VERSION"

echo "Detecting tool versions..."

# Get versions with error handling
echo "Getting AWS CLI version..."
AWS_CLI_VERSION=$(aws --version 2>&1 | cut -d/ -f2 | cut -d' ' -f1 || echo "unknown")

echo "Getting AWS CDK version..."
AWS_CDK_VERSION=$(cdk --version 2>/dev/null | cut -d' ' -f1 || echo "unknown")

echo "Getting AWS Amplify version..."
AWS_AMPLIFY_VERSION=$(amplify --version 2>/dev/null || echo "unknown")

echo "Getting EB version..."
EB_VERSION=$(eb --version 2>/dev/null | cut -d' ' -f3 || echo "unknown")

echo "Getting PHP version..."
PHP_VERSION=$(php --version | head -n1 | cut -d' ' -f2 | cut -d'-' -f1)-fpm

echo "Getting NVM version..."
export NVM_DIR="/usr/local/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
NVM_VERSION=$(nvm --version 2>/dev/null || echo "unknown")

echo "Getting Node version..."
NODE_VERSION=$(node --version | sed 's/v//' || echo "unknown")

echo "Getting NPM version..."
NPM_VERSION=$(npm --version || echo "unknown")

echo "Getting Composer version..."
COMPOSER_VERSION=$(composer --version 2>/dev/null | cut -d' ' -f3 || echo "unknown")

echo "Getting Python3 version..."
PYTHON3_VERSION=$(python3 --version | cut -d' ' -f2 || echo "unknown")

echo "Getting Python2 version..."
PYTHON2_VERSION=$(python2 --version 2>&1 | cut -d' ' -f2 || echo "unknown")

echo "Getting Ansible version..."
ANSIBLE_VERSION=$(ansible --version 2>/dev/null | head -n1 | cut -d' ' -f3 | sed 's/\]//' || echo "unknown")

echo "Getting Acquia CLI version..."
ACLI_VERSION=$(acli --version 2>/dev/null | cut -d' ' -f3 || echo "unknown")

echo "Detected versions:"
echo "  AWS CLI: $AWS_CLI_VERSION"
echo "  AWS CDK: $AWS_CDK_VERSION"
echo "  AWS Amplify: $AWS_AMPLIFY_VERSION"
echo "  EB: $EB_VERSION"
echo "  PHP: $PHP_VERSION"
echo "  NVM: $NVM_VERSION"
echo "  Node: $NODE_VERSION"
echo "  NPM: $NPM_VERSION"
echo "  Composer: $COMPOSER_VERSION"
echo "  Python3: $PYTHON3_VERSION"
echo "  Python2: $PYTHON2_VERSION"
echo "  Ansible: $ANSIBLE_VERSION"
echo "  Acquia CLI: $ACLI_VERSION"

# Update README.md
echo "Updating README.md..."
sed -i.bak "
s/\* aws cli: .*/\* aws cli: $AWS_CLI_VERSION/
s/\* aws cdk: .*/\* aws cdk: $AWS_CDK_VERSION/
s/\* aws amplify: .*/\* aws amplify: $AWS_AMPLIFY_VERSION/
s/\* eb: .*/\* eb: $EB_VERSION/
s/\* php: .*/\* php: $PHP_VERSION/
s/\* nvm: .*/\* nvm: $NVM_VERSION/
s/  \* node: .*/  \* node: v$NODE_VERSION/
s/  \* npm: .*/  \* npm: $NPM_VERSION/
s/\* composer: .*/\* composer: $COMPOSER_VERSION/
s/\* python3: .*/\* python3: $PYTHON3_VERSION/
s/\* ansible: .*/\* ansible: $ANSIBLE_VERSION/
s/\* acli: .*/\* acli: $ACLI_VERSION/
" "$README_FILE"

# Update CHANGELOG.md for specified version
echo "Updating CHANGELOG.md for version $VERSION..."
# Escape dots in version for sed regex
ESCAPED_VERSION=$(echo $VERSION | sed 's/\./\\./g')
sed -i.bak "
/## \[$ESCAPED_VERSION\]/,/^## \[/ {
/^## \[$ESCAPED_VERSION\]/,/^## \[/ {
/^## \[/!{
s/- AWS CLI: .*/- AWS CLI: $AWS_CLI_VERSION/
s/- AWS CDK: .*/- AWS CDK: $AWS_CDK_VERSION/
s/- AWS Amplify: .*/- AWS Amplify: $AWS_AMPLIFY_VERSION/
s/- EB CLI: .*/- EB CLI: $EB_VERSION/
s/- PHP: .*/- PHP: $PHP_VERSION/
s/- NVM: .*/- NVM: $NVM_VERSION/
s/  - Node: .*/  - Node: v$NODE_VERSION/
s/  - NPM: .*/  - NPM: $NPM_VERSION/
s/- Composer: .*/- Composer: $COMPOSER_VERSION/
s/- Python3: .*/- Python3: $PYTHON3_VERSION/
s/- Python2: .*/- Python2: $PYTHON2_VERSION/
s/- Ansible: .*/- Ansible: $ANSIBLE_VERSION/
s/- Acquia CLI: .*/- Acquia CLI: $ACLI_VERSION/
}
}
}" "$CHANGELOG_FILE"

# Clean up backup files
rm -f "$README_FILE.bak" "$CHANGELOG_FILE.bak"

echo "Version update complete!"