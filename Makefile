GO_VERSION := $(shell curl -s https://go.dev/VERSION?m=text | head -n 1 | sed 's/go//')
GO_DOWNLOAD_URL := https://go.dev/dl/go$(GO_VERSION).linux-amd64.tar.gz
BASHRC := $(HOME)/.bashrc

.PHONY: all neovim-only cli-tools

all: /usr/bin/tree-sitter /usr/bin/gcc-14 /usr/bin/python3 $(HOME)/.nvm/nvm.sh /usr/local/go/bin/go /opt/nvim-linux-x86_64/bin/nvim

neovim-only: /usr/bin/tree-sitter /usr/bin/gcc-14 $(HOME)/.nvm/nvm.sh /opt/nvim-linux-x86_64/bin/nvim

cli-tools:
	sudo apt update && sudo apt install -y curl fzf ripgrep gzip

/usr/bin/tree-sitter: cli-tools
	curl -LO https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-x64.gz
	gunzip -f tree-sitter-linux-x64.gz
	sudo chmod +x tree-sitter-linux-x64
	sudo mv tree-sitter-linux-x64 /usr/bin/tree-sitter

/usr/bin/gcc-14:
	sudo apt update && sudo apt install -y gcc-14 g++-14 cmake
	sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-14 333
	sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-14 333
	sudo update-alternatives --set gcc /usr/bin/gcc-14
	sudo update-alternatives --set g++ /usr/bin/g++-14

/usr/bin/python3:
	sudo apt update && sudo apt install -y python3 python3-venv python3-pip
	python3 -m pip install --upgrade pip

$(HOME)/.nvm/nvm.sh:
	curl -o- 'https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh' | bash
	source $(BASHRC)
	nvm install 23
	nvm use 23

/usr/local/go/bin/go:
	wget -q --show-progress -O go.tar.gz $(GO_DOWNLOAD_URL)
	sudo rm -rf /usr/local/go
	sudo tar -C /usr/local/ -xzf go.tar.gz
	sudo rm -f go.tar.gz
	@grep -q "export PATH=/usr/local/go/bin" $(BASHRC) || echo 'export PATH=/usr/local/go/bin:$$PATH' >> $(BASHRC)
	@grep -q "export GOROOT=/usr/local/go" $(BASHRC) || echo 'export GOROOT=/usr/local/go' >> $(BASHRC)
	@grep -q "export GOPATH=$$HOME/go" $(BASHRC) || echo 'export GOPATH=$$HOME/go' >> $(BASHRC)
	@grep -q "export PATH=$$HOME/go/bin" $(BASHRC) || echo 'export PATH=$$HOME/go/bin:$$PATH' >> $(BASHRC)

# Neovim
/opt/nvim-linux-x86_64/bin/nvim:
	curl -LO 'https://github.com/neovim/neovim/releases/stable/download/nvim-linux-x86_64.tar.gz'
	sudo rm -rf /opt/nvim-linux-x86_64
	sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
	sudo rm -f nvim-linux-x86_64.tar.gz
	@grep -q "export PATH=/opt/nvim-linux-x86_64/bin" $(BASHRC) || echo 'export PATH=/opt/nvim-linux-x86_64/bin:$$PATH' >> $(BASHRC)
