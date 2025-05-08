#!/bin/bash

# Update the package list
echo "Updating package list..."
sudo apt update

# Upgrade specific packages
PACKAGES=("curl" "vim" "git")

echo "Upgrading selected packages: ${PACKAGES[*]}"
for pkg in "${PACKAGES[@]}"; do
    sudo apt install --only-upgrade -y "$pkg"
done

echo "Package updates complete."
