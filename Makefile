GO_VERSION := $(shell curl -s https://go.dev/VERSION?m=text | head -n 1 | sed 's/go//')
GO_DOWNLOAD_URL := https://go.dev/dl/go$(GO_VERSION).linux-amd64.tar.gz

.PHONY: all curl git c python nvm go neovim

all: curl git c python nvm go neovim

curl:
	sudo apt install curl -y

git:
	sudo add-apt-repository ppa:git-core/ppa
	sudo apt update
	sudo apt install git

c:
	sudo apt install gcc-14 g++-14 cmake -y
	sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-14 333
	sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-14 333

python:
	sudo apt install python3 python3-venv pip -y
	python3 -m pip install --upgrade pip

nvm:
	curl -o- 'https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh' | bash
	nvm install 23
	nvm use 23

go:
	wget -q --show-progress -O go.tar.gz $(GO_DOWNLOAD_URL)
	sudo rm -rf /usr/local/go
	sudo tar -C /usr/local/ -xzf go.tar.gz
	sudo rm -f go.tar.gz
	@if ! grep -q "export PATH=/usr/local/go/bin:\$$PATH" ~/.bashrc; then \
		echo "export PATH=/usr/local/go/bin:\$$PATH" >> ~/.bashrc; \
	fi
	@if ! grep -q "export GOROOT=/usr/local/go" ~/.bashrc; then \
		echo "export GOROOT=/usr/local/go" >> ~/.bashrc; \
	fi
	@if ! grep -q "export GOPATH=\$$HOME/go" ~/.bashrc; then \
		echo "export GOPATH=\$$HOME/go" >> ~/.bashrc; \
	fi
	@if ! grep -q "export PATH=~/go/bin:\$$PATH" ~/.bashrc; then \
		echo "export PATH=~/go/bin:\$$PATH" >> ~/.bashrc; \
	fi

neovim:
	curl -LO 'https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz'
	sudo rm -rf /opt/nvim*
	sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
	sudo rm -f nvim-linux-x86_64.tar.gz
	@if ! grep -q "export PATH=/opt/nvim-linux-x86_64/bin:\$PATH" ~/.bashrc; then \
		echo "export PATH=/opt/nvim-linux-x86_64/bin:\$PATH" >> ~/.bashrc \
	fi
