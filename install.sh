#!/bin/bash

# Install Python
sudo apt install python3 python3-venv pip -y
python3 -m pip install --upgrade pip 

# Install Node 23
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
nvm install 23

# Install Go
# Download latest
mkdir -p "$HOME/bin"
GO_VERSION=$(curl -s https://go.dev/VERSION?m=text | head -n 1 | sed 's/go//')
GO_DOWNLOAD_URL="https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz"
wget -q --show-progress -O go.tar.gz "$GO_DOWNLOAD_URL"

# Remove old, unpack new
rm -rf "$HOME/bin/go"
tar -C "$HOME/bin" -xzf go.tar.gz
rm go.tar.gz

# Add Go to PATH if not already present
if ! grep -q "export PATH=\$HOME/bin/go/bin:\$PATH" ~/.bashrc; then
    echo "export PATH=\$HOME/bin/go/bin:\$PATH" >> ~/.bashrc
fi

sudo ln -sf ~/bin/go/bin/go /usr/bin/go
export PATH="$HOME/bin/go/bin:$PATH"
