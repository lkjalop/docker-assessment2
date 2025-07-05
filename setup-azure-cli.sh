#!/bin/bash

# Azure CLI Installation Script
# Student: Leomark Jalop (leomark.jalop@studytafensw.edu.au)

echo "Setting up Azure CLI for Docker Assessment"
echo "Student: leomark.jalop@studytafensw.edu.au"
echo "=========================================="

# Detect OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Detected Linux system"
    
    # Check if running on Ubuntu/Debian
    if command -v apt-get &> /dev/null; then
        echo "Installing Azure CLI on Ubuntu/Debian..."
        
        # Update package index
        sudo apt-get update
        
        # Install required packages
        sudo apt-get install -y ca-certificates curl apt-transport-https lsb-release gnupg
        
        # Download and install the Microsoft signing key
        curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
        
        # Add Azure CLI software repository
        AZ_REPO=$(lsb_release -cs)
        echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | sudo tee /etc/apt/sources.list.d/azure-cli.list
        
        # Update package index and install Azure CLI
        sudo apt-get update
        sudo apt-get install -y azure-cli
        
    elif command -v yum &> /dev/null; then
        echo "Installing Azure CLI on RHEL/CentOS..."
        
        # Import Microsoft repository key
        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
        
        # Add Azure CLI repository
        sudo sh -c 'echo -e "[azure-cli]
name=Azure CLI
baseurl=https://packages.microsoft.com/yumrepos/azure-cli
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/azure-cli.repo'
        
        # Install Azure CLI
        sudo yum install -y azure-cli
    fi
    
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Detected macOS system"
    
    # Check if Homebrew is installed
    if command -v brew &> /dev/null; then
        echo "Installing Azure CLI using Homebrew..."
        brew update && brew install azure-cli
    else
        echo "Homebrew not found. Please install Homebrew first:"
        echo "/bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        exit 1
    fi
    
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    echo "Detected Windows system"
    echo "Please install Azure CLI for Windows:"
    echo "1. Download from: https://aka.ms/installazurecliwindows"
    echo "2. Run the installer"
    echo "3. Restart your terminal"
    exit 1
fi

# Verify installation
echo ""
echo "Verifying Azure CLI installation..."
if command -v az &> /dev/null; then
    echo "✓ Azure CLI installed successfully!"
    az --version
    echo ""
    echo "Next steps:"
    echo "1. Login to Azure: az login --use-device-code"
    echo "2. Use email: leomark.jalop@studytafensw.edu.au"
    echo "3. Run the deployment script: ./deploy-azure.sh"
else
    echo "✗ Azure CLI installation failed!"
    echo "Please try manual installation:"
    echo "https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
    exit 1
fi

echo ""
echo "Azure CLI setup complete!"
echo "Student: leomark.jalop@studytafensw.edu.au"
