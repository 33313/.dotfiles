SHELL := /bin/bash
LOCAL := $(HOME)/.local
LOCAL_BIN := $(LOCAL)/bin
BASHRC := $(HOME)/.bashrc
LOG := /tmp/install.log

GO_VER := $(shell curl -s https://go.dev/VERSION?m=text | head -n 1 | sed 's/go//')
GO_URL := https://go.dev/dl/go$(GO_VER).linux-amd64.tar.gz
NVIM_URL := https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz
TS_URL := https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-x64.gz

define TASK_SCRIPT
#!/bin/bash
msg="$$1"; shift; cmd="$$@"
tput sc
R='\033[0;31m'
G='\033[0;32m'
B='\033[0;34m'
NC='\033[0m'
sp="⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"
printf "   $$msg..."
eval "$$cmd" > $(LOG) 2>&1 &
pid=$$!
while kill -0 $$pid 2>/dev/null; do
    for i in {0..9}; do
        printf "\r $${B}$${sp:i:1}$${NC} $$msg..."
        sleep 0.1
    done
done
wait $$pid
ret=$$?
tput rc
tput el
if [ $$ret -eq 0 ]; then
    printf " $${G}✅$${NC}  $$msg $${G}(DONE)$${NC}\n"
else
    printf " $${R}❌$${NC}  $$msg $${R}(FAIL)$${NC}\n"
    echo "------------------------------------------------"
    cat $(LOG)
    echo "------------------------------------------------"
    exit 1
fi
endef
export TASK_SCRIPT

TASK = @bash /tmp/task.sh $(1) '$(2)'

.PHONY: help all nvim-only dep-all dep-nvim dir setup-path check-user init-ui clean-ui

help:
	@echo "Usage:"
	@echo "  make nvim-only"
	@echo "  make all"

init-ui:
	@echo "$$TASK_SCRIPT" > /tmp/task.sh
	@chmod +x /tmp/task.sh
	@echo ""
	@printf " 😼🔧 Starting installation...\n"

clean-ui:
	@rm -f /tmp/task.sh
	@echo "--------------------------------"
	@printf " 😺\033[1;32m All done! Please restart your terminal or run \`source ~/.bashrc\`.\033[0m\n"

dep-nvim:
	@sudo -v
	$(call TASK, "Install: System dependencies (nvim-only)", sudo apt-get update && sudo apt-get install -y curl fzf ripgrep gzip)

dep-all:
	@sudo -v
	$(call TASK, "Install: System dependencies (all)", sudo apt-get update && sudo apt-get install -y curl fzf ripgrep gzip python3 python3-venv python3-pip gcc-14 g++-14 cmake)
	$(call TASK, "Chore: Set gcc-14/g++-14 as default", sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-14 333 && sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-14 333 && sudo update-alternatives --set gcc /usr/bin/gcc-14 && sudo update-alternatives --set g++ /usr/bin/g++-14)

check-user:
	@if [ "$$(id -u)" -eq 0 ]; then echo "❌ ERROR: Run without sudo"; exit 1; fi

dir:
	@mkdir -p $(LOCAL_BIN)

nvim-only: check-user init-ui dep-nvim dir fix-bashrc install-ts install-nvim install-nvm setup-path clean-ui

all: check-user init-ui dep-all dir fix-bashrc install-ts install-nvim install-go install-nvm setup-path clean-ui

fix-bashrc:
	$(call TASK, "Check: .bashrc header", touch $(BASHRC) && (head -n 1 $(BASHRC) | grep -q "^#!/bin/bash" || sed -i '1i#!/bin/bash' $(BASHRC)))

install-ts:
	$(call TASK, "Install: tree-sitter", curl -L $(TS_URL) -o $(LOCAL_BIN)/tree-sitter.gz && gunzip -f $(LOCAL_BIN)/tree-sitter.gz && chmod +x $(LOCAL_BIN)/tree-sitter)

install-nvim:
	$(call TASK, "Install: Neovim (stable)", rm -rf $(LOCAL)/nvim-linux-x86_64 && curl -L $(NVIM_URL) | tar -xz -C $(LOCAL) && ln -sf $(LOCAL)/nvim-linux-x86_64/bin/nvim $(LOCAL_BIN)/nvim)

install-go:
	$(call TASK, "Install: Go", rm -rf $(LOCAL)/go && curl -L $(GO_URL) | tar -xz -C $(LOCAL) && ln -sf $(LOCAL)/go/bin/go $(LOCAL_BIN)/go)
	$(call TASK, "Chore: Set GOROOT", grep -q 'GOROOT=$(LOCAL)/go' $(BASHRC) || echo 'export GOROOT=$(LOCAL)/go' >> $(BASHRC))
	$(call TASK, "Chore: Set GOPATH", grep -q 'GOPATH=$$HOME/go' $(BASHRC) || echo 'export GOPATH=$$HOME/go' >> $(BASHRC))
	$(call TASK, "Chore: Add Go to PATH", grep -q 'go/bin' $(BASHRC) || echo 'export PATH=$$HOME/go/bin:$$PATH' >> $(BASHRC))

install-nvm:
	$(call TASK, "Install: nvm", if [ ! -d "$(HOME)/.nvm" ]; then curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | NVM_DIR="$(HOME)/.nvm" bash; fi)
	$(call TASK, "Install: Node.js 23", export NVM_DIR="$(HOME)/.nvm" && [ -s "$$NVM_DIR/nvm.sh" ] && \. "$$NVM_DIR/nvm.sh" && nvm install 23 && nvm use 23 && nvm alias default 23)

setup-path:
	$(call TASK, "Chore: Add ~/.local/bin to PATH", grep -q 'export PATH=$(LOCAL_BIN):$$PATH' $(BASHRC) || echo 'export PATH=$(LOCAL_BIN):$$PATH' >> $(BASHRC))