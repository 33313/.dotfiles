# Arch install. This repo is designed to BE ~/.config — once it's cloned
# there the configs are live; this Makefile only installs the packages
# they depend on. See README.md.
PACMAN := sudo pacman -S --needed

DESKTOP := hyprland uwsm kitty ghostty cliphist wl-clipboard wl-clip-persist
NVIM    := neovim ripgrep fzf gcc make unzip nodejs npm

.PHONY: help all desktop nvim check-arch

help:
	@echo "Usage:"
	@echo "  make all      - desktop + neovim packages"
	@echo "  make desktop  - hyprland, terminals, clipboard tools, noctalia"
	@echo "  make nvim     - neovim and its LSP/treesitter toolchain"

all: desktop nvim

check-arch:
	@command -v pacman >/dev/null || { echo "ERROR: pacman not found — this branch targets Arch"; exit 1; }

desktop: check-arch
	$(PACMAN) $(DESKTOP)
# noctalia-shell (bar/launcher) is in the CachyOS repos but not vanilla Arch
	@if pacman -Si noctalia-shell >/dev/null 2>&1; then \
		$(PACMAN) noctalia-shell; \
	else \
		echo "noctalia-shell not in your repos — install it from the AUR: paru -S noctalia-shell"; \
	fi

nvim: check-arch
	$(PACMAN) $(NVIM)
