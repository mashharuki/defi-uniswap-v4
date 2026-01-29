#!/bin/bash

set -e

echo "🔧 Setting up Uniswap V4 development environment..."

# Update package lists
echo "📦 Updating package lists..."
sudo apt-get update

# Install essential build tools
echo "🛠️ Installing essential build tools..."
sudo apt-get install -y \
    build-essential \
    curl \
    wget \
    git \
    ca-certificates \
    gnupg \
    lsb-release

# Install Foundry
echo "⚒️ Installing Foundry..."
if ! command -v forge &> /dev/null; then
    curl -L https://foundry.paradigm.xyz | bash
    export PATH="$HOME/.foundry/bin:$PATH"
    source ~/.bashrc || source ~/.zshrc || true
    foundryup
else
    echo "✅ Foundry already installed"
fi

# Verify installations
echo "🔍 Verifying installations..."
echo "Git version: $(git --version)"
echo "Rust version: $(rustc --version)"
echo "Cargo version: $(cargo --version)"
if command -v forge &> /dev/null; then
    echo "Forge version: $(forge --version)"
fi
if command -v cast &> /dev/null; then
    echo "Cast version: $(cast --version)"
fi
if command -v anvil &> /dev/null; then
    echo "Anvil version: $(anvil --version)"
fi

# Install Foundry dependencies in the project
echo "📚 Installing Foundry dependencies..."
cd /workspaces/defi-uniswap-v4/foundry
forge install

echo "✨ Setup complete! You're ready to start developing."
echo ""
echo "📝 Available commands:"
echo "  - forge build       : Compile contracts"
echo "  - forge test        : Run tests"
echo "  - forge fmt         : Format Solidity code"
echo "  - anvil             : Start local Ethereum node"
