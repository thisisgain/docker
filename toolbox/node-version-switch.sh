#!/bin/bash

# Function to handle Node.js version switching
switch_node_version() {
  if [ -n "$NODE_VERSION" ]; then
    # Get current version without the "v" prefix
    CURRENT_VERSION=$(node -v 2>/dev/null | sed "s/^v//")

    echo "****** $NODE_VERSION $CURRENT_VERSION"

    # Check if versions are different (accounting for version format differences)
    if [[ "$CURRENT_VERSION" != "$NODE_VERSION"* ]]; then
      echo "Switching from Node.js $CURRENT_VERSION to $NODE_VERSION"
      . "$NVM_DIR/nvm.sh"
      nvm install "$NODE_VERSION" >/dev/null 2>&1
      nvm use "$NODE_VERSION" >/dev/null 2>&1
      nvm alias default "$NODE_VERSION" >/dev/null 2>&1
    fi
  fi
}

# Run the function
switch_node_version