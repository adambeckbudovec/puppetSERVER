#!/bin/bash

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root or with sudo."
    exit 1
fi

# Detect the package manager
if command -v apt &> /dev/null; then
    # Debian/Ubuntu
    package_manager="apt"
elif command -v yum &> /dev/null; then
    # Red Hat/CentOS
    package_manager="yum"
else
    echo "Unsupported distribution. Please install Puppet Server manually."
    exit 1
fi

# Install Puppet Server
case $package_manager in
    "apt")
        apt update
        apt install -y puppetserver
        ;;
    "yum")
        rpm -Uvh https://yum.puppet.com/puppet7-release-el-7.noarch.rpm
        yum install -y puppetserver
        ;;
    *)
        echo "Unsupported package manager. Please install Puppet Server manually."
        exit 1
        ;;
esac

# Start Puppet Server
systemctl start puppetserver
systemctl enable puppetserver

# Check if Puppet Server installation was successful
if pgrep -x "java" > /dev/null; then
    echo "Puppet Server has been successfully installed and started."
else
    echo "Failed to start Puppet Server. Please check for errors."
    exit 1
fi
