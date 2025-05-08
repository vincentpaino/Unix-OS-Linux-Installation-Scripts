#!/bin/bash

# Update the package list
echo "Updating package list..."
sudo apt update

# Check and install network tools
NETWORK_TOOLS=("net-tools" "iproute2" "dnsutils" "network-manager")

echo "Checking and upgrading network tools..."
for tool in "${NETWORK_TOOLS[@]}"; do
    sudo apt install --only-upgrade -y "$tool"
done

# Display current network configuration
echo "Displaying current network configuration:"
ip addr show

echo "Network tools update complete."
