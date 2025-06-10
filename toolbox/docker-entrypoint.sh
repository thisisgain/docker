#!/bin/bash

# Check if NODE_VERSION environment variable is set and different from default
if [ -n "$NODE_VERSION" ] && [ "$NODE_VERSION" != "$DEFAULT_NODE_VERSION" ]; then
  echo "Installing Node.js $NODE_VERSION..."
  export NVM_DIR=/usr/local/.nvm
  # Source the nvm.sh script to make nvm command available
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  
  # Now we can use nvm
  nvm install $NODE_VERSION && nvm alias default $NODE_VERSION && nvm use default
  
  # Update symlinks
  ln -sf $NVM_DIR/versions/node/v$NODE_VERSION/bin/node /usr/local/bin/node
  ln -sf $NVM_DIR/versions/node/v$NODE_VERSION/bin/npm /usr/local/bin/npm
  ln -sf $NVM_DIR/versions/node/v$NODE_VERSION/bin/npx /usr/local/bin/npx
fi

# Execute the command passed to the container
exec "$@"