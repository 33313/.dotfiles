#!/bin/bash
# Install Go
# Download latest
GO_VERSION=$(curl -s https://go.dev/VERSION?m=text | head -n 1 | sed 's/go//')
GO_DOWNLOAD_URL="https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz"
wget -q --show-progress -O go.tar.gz "$GO_DOWNLOAD_URL"

# Remove old, unpack new
rm -rf "/usr/local/go/bin"
tar -C "/usr/local" -xzf go.tar.gz
rm go.tar.gz

# Add Go to PATH if not already present
if ! grep -q "export PATH=/usr/local/go/bin:\$PATH" ~/.bashrc; then
    echo "export PATH=/usr/local/go/bin:\$PATH" >> ~/.bashrc
fi

# Set GOROOT
if ! grep -q "export GOROOT=/usr/local/go:\$PATH" ~/.bashrc; then
    echo "export GOROOT=/usr/local/go:\$PATH" >> ~/.bashrc
fi

# Set GOPATH
if ! grep -q "export GOPATH=\$HOME/go:\$PATH" ~/.bashrc; then
    echo "export GOPATH=\$HOME/go:\$PATH" >> ~/.bashrc
fi

source ~/.bashrc
