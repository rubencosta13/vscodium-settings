#!/usr/bin/env bash

# ===================================================
# VSCODIUM SETUP RESTORE SCRIPT
# Works on macOS, Linux, and Windows (WSL / Git Bash)
# ===================================================

set -e

echo "Starting VSCodium setup restore..."

# Detect OS
OS_TYPE="$(uname -s)"
case "$OS_TYPE" in
    Darwin*)    PLATFORM="macos"; USER_DIR="$HOME/Library/Application Support/VSCodium/User";;
    Linux*)     PLATFORM="linux"; USER_DIR="$HOME/.config/VSCodium/User";;
    CYGWIN*|MINGW*|MSYS*) PLATFORM="windows"; USER_DIR="$APPDATA/VSCodium/User";;
    *)          echo "Unsupported OS: $OS_TYPE"; exit 1;;
esac

echo "Detected platform: $PLATFORM"
echo "VSCodium user directory: $USER_DIR"

# Ensure VSCodium user dir exists
mkdir -p "$USER_DIR"

# Copy settings and snippets
echo "Copying settings.json..."
cp -f settings.json "$USER_DIR/"

echo "Copying snippets..."
mkdir -p "$USER_DIR/snippets"
cp -rf snippets/* "$USER_DIR/snippets/"

# Install extensions
if [ -f "extensions.txt" ]; then
    echo "Installing extensions..."
    while IFS= read -r extension; do
        codium --install-extension "$extension" || true
    done < extensions.txt
else
    echo "No extensions.txt found. Skipping extensions installation."
fi

echo "VSCodium setup restore completed!"

