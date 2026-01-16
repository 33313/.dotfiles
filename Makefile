SHELL := /bin/bash
LOCAL := $(HOME)/.local
LOCAL_BIN := $(LOCAL)/bin
BASHRC := $(HOME)/.bashrc

GO_VERSION := $(shell curl -s https://go.dev/VERSION?m=text | head -n 1 | sed 's/go//')
GO_URL := https://go.dev/dl/go$(GO_VERSION).linux-amd64.tar.gz
NVIM_URL := https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
TS_URL := https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-x64.gz

.PHONY: help all nvim-only dep-all dep-nvim dir setup-path

help:
	@echo "Usage:"
	@echo "  make nvim-only      # Install Neovim, Treesitter, NVM (Skip Go/GCC/Python)"
	@echo "  make all            # Install everything (Recommended)"

dep-nvim:
	apt-get update && apt-get install -y curl fzf ripgrep gzip

dep-all:
	apt-get update && apt-get install -y curl fzf ripgrep gzip python3 python3-venv python3-pip gcc-14 g++-14 cmake
	update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-14 333
	update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-14 333
	update-alternatives --set gcc /usr/bin/gcc-14
	update-alternatives --set g++ /usr/bin/g++-14

nvim-only: dir $(LOCAL_BIN)/tree-sitter $(LOCAL_BIN)/nvim $(HOME)/.nvm/nvm.sh setup-path

all: dir $(LOCAL_BIN)/tree-sitter $(LOCAL_BIN)/nvim $(LOCAL_BIN)/go $(HOME)/.nvm/nvm.sh setup-path

dir:
	@mkdir -p $(LOCAL_BIN)

$(LOCAL_BIN)/tree-sitter:
	curl -L $(TS_URL) -o $(LOCAL_BIN)/tree-sitter.gz
	gunzip -f $(LOCAL_BIN)/tree-sitter.gz
	chmod +x $(LOCAL_BIN)/tree-sitter

$(LOCAL_BIN)/nvim:
	rm -rf $(LOCAL)/nvim-linux64
	curl -L $(NVIM_URL) | tar -xz -C $(LOCAL)
	ln -sf $(LOCAL)/nvim-linux64/bin/nvim $(LOCAL_BIN)/nvim

$(LOCAL_BIN)/go:
	rm -rf $(LOCAL)/go
	curl -L $(GO_URL) | tar -xz -C $(LOCAL)
	ln -sf $(LOCAL)/go/bin/go $(LOCAL_BIN)/go
	@grep -q 'export GOROOT=$(LOCAL)/go' $(BASHRC) || echo 'export GOROOT=$(LOCAL)/go' >> $(BASHRC)
	@grep -q 'export GOPATH=$$HOME/go' $(BASHRC) || echo 'export GOPATH=$$HOME/go' >> $(BASHRC)
	@grep -q 'export PATH=$$HOME/go/bin:$$PATH' $(BASHRC) || echo 'export PATH=$$HOME/go/bin:$$PATH' >> $(BASHRC)

$(HOME)/.nvm/nvm.sh:
	[ -d "$(HOME)/.nvm" ] || curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

setup-path:
	@grep -q 'export PATH=$(LOCAL_BIN):$$PATH' $(BASHRC) || echo 'export PATH=$(LOCAL_BIN):$$PATH' >> $(BASHRC)
	@echo "Installation complete. Please run: source ~/.bashrc"