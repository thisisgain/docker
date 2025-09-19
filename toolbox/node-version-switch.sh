#!/bin/bash

# Function to handle Node.js version switching
switch_node_version() {
  if [ -n "$NODE_VERSION" ]; then
    # Get current version without the "v" prefix
    CURRENT_VERSION=$(node -v 2>/dev/null | sed "s/^v//")

    # Check if versions are different (accounting for version format differences)
    if [[ "$CURRENT_VERSION" != "$NODE_VERSION"* ]]; then
      . "$NVM_DIR/nvm.sh"
      nvm install "$NODE_VERSION" >/dev/null 2>&1
      nvm use "$NODE_VERSION" >/dev/null 2>&1
      nvm alias default "$NODE_VERSION" >/dev/null 2>&1
    fi
  fi
}

# Run the function
switch_node_version