#!/bin/bash

# Define remote URL for git_changelog script
SCRIPT_URL="https://raw.githubusercontent.com/JSTLWK/changelog_by_local_ai/refs/heads/master/git_changelog.sh"

# Ensure the script is run as root (for installing packages)
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root (use sudo)"
    exit 1
fi

echo "Installing dependencies..."

# Install Git if not installed
if ! command -v git &> /dev/null; then
    echo "Git not found. Make sure you install it first"
    exit 1;
    apt update && apt install -y git || yum install -y git || brew install git
else
    echo "Git is already installed."
fi

# Install Ollama if not installed
if ! command -v ollama &> /dev/null; then
    echo "Ollama not found. Installing..."
    curl -fsSL https://ollama.com/install.sh | sh
else
    echo "Ollama is already installed."
fi

# Download the git_changelog script
echo "Downloading git_changelog script..."
curl -o /usr/local/bin/git_changelog "$SCRIPT_URL"

# Make the script executable
chmod +x /usr/local/bin/git_changelog

echo "Installation complete! You can now run:"
echo "  git_changelog"
