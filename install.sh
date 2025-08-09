#!/bin/bash

# Install Python
sudo apt install python3 python3-venv pip -y
python3 -m pip install --upgrade pip 

# Install Node 23
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
nvm install 23

