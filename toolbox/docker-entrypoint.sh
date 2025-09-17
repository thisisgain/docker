#!/bin/bash

# Check if NODE_VERSION environment variable is set
if [ -n "$NODE_VERSION" ]; then
  # Get current version without the "v" prefix
  CURRENT_VERSION=$(node -v 2>/dev/null | sed "s/^v//")

  # Check if versions are different (accounting for version format differences)
  if [[ "$CURRENT_VERSION" != "$NODE_VERSION"* ]]; then
    echo "Switching from Node.js $CURRENT_VERSION to $NODE_VERSION"
    export NVM_DIR=/usr/local/.nvm
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

    # Install and use the specified version
    nvm install "$NODE_VERSION" >/dev/null 2>&1
    nvm use "$NODE_VERSION" >/dev/null 2>&1
    nvm alias default "$NODE_VERSION" >/dev/null 2>&1

    # Update symlinks
    ln -sf "$NVM_DIR/versions/node/v$NODE_VERSION/bin/node" /usr/local/bin/node
    ln -sf "$NVM_DIR/versions/node/v$NODE_VERSION/bin/npm" /usr/local/bin/npm
    ln -sf "$NVM_DIR/versions/node/v$NODE_VERSION/bin/npx" /usr/local/bin/npx
  fi
fi

# Execute the command passed to the container
exec "$@"