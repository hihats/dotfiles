#!/bin/bash

# Install global npm packages from package.json
echo "Installing global npm packages..."

# Check if package.json exists
if [ ! -f "package.json" ]; then
    echo "Error: package.json not found"
    exit 1
fi

# Install packages from the install-globals script
cat package.json | jq -r '.globalPackages[]' | xargs npm install -g
echo "Global npm packages installation completed"