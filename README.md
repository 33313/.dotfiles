# Dotfiles (arch branch)

Configs for an Arch/CachyOS + Hyprland desktop. This repo is designed to **be** `~/.config`: the `.gitignore` ignores everything by default and whitelists only what's tracked, so it coexists with the rest of your config directory.

| Path | What it is |
| ---- | ---------- |
| `hypr/` | Hyprland config in Lua (`hyprland.lua`, keybinds in `hyprland/bind.lua`). Needs Hyprland ≥ 0.55 (native Lua config). |
| `kitty/` | Kitty with the Charcoal & Amber palette (colors baked in). |
| `ghostty/` | Same palette for Ghostty. |
| `nvim/` | Neovim config — see below. |
| `Makefile` | Installs the packages the configs depend on (pacman). |

# Installation

If you DON'T have a `~/.config` directory:
```bash
git clone -b arch https://github.com/33313/.dotfiles.git ~/.config
cd ~/.config && make all   # or: make help
```

If you DO have one (you almost certainly do), turn it into the repo in place:
```bash
cd ~/.config
git init -b arch
git remote add origin https://github.com/33313/.dotfiles.git
git fetch origin
git checkout arch   # refuses to overwrite existing files — back those up and rerun
make all
```

> [!WARNING]
> `hypr/hyprland.lua` pins monitors (`DP-1`, `HDMI-A-2`) and workspace layout to my hardware. Edit the `hl.monitor` blocks at the top before starting Hyprland, or you'll get whatever Hyprland guesses.

Notes:
* `make all` = `make desktop` + `make nvim`; run either alone if you only want half.
* noctalia-shell (bar/launcher, autostarted from `hyprland.lua`) is in the CachyOS repos; on vanilla Arch get it from the AUR (`paru -S noctalia-shell`).
* The cursor theme referenced in `hyprland.lua` (Notwaita-Black) isn't packaged here — install it separately or swap the `hl.env` lines to your own.

# Neovim
My config is built in a way that makes it really easy to modify.

The directory structure looks like this:

| Path | Purpose |
| ---- | ------- |
| `nvim/init.lua` | Bootstraps the config and sets the theme. |
| `nvim/lua/config` | General config: Keybinds, undodir, package manager, workarounds. |
| `nvim/lua/plugins` | Plugin config: This is where you can install/modify/remove plugins. |

## LSP / Language Server Protocol / "Why is there no autocomplete for X?"
The main thing you will likely want to modify are the LSPs. To do this:
1. Open `nvim/lua/plugins/lsp.lua`.
2. Find the line that starts with `require('mason-lspconfig').setup({`. It should be near the bottom.
3. You should see something like `ensure_installed = { ... }`. Inside of those brackets is a list of active LSPs.

To add new LSPs, you must first know what they're actually called. Use [this file](https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md) or `:help lspconfig-all` to see all available LSPs (and their names).

To remove LSPs, you need to remove them from the `ensure_installed` list.

Save your changes with `:w` and verify that they're working.

## Theme
The colorscheme is tokyonight with the full palette overridden to Charcoal & Amber (`nvim/lua/plugins/colors.lua`), so the editor matches the terminals. To use a different theme:
1. Open `nvim/lua/plugins/colors.lua`.
2. In the `return` statement near the bottom, add a new item to the list: `{ "author/myawesometheme.nvim" },`.
3. Save the file.
4. Open `nvim/init.lua` and change the `setTheme(...)` name to the one your new theme's README gives you.
5. That's it! Restart your Neovim and enjoy your new theme.

## Usage
Some general usage tips specific to my config:
* Make sure to `cd` into your project before opening it with `nvim .`, as Telescope gets its file list from `pwd`.
* There is no file tree. Keep reading to find out how I navigate without one (at 10x your speed).
* You can use comment labels like: `// TODO: `, `// WARNING: `, `// INFO: `, etc. They light up with nice colors. You can then jump between them (explained below).

### Finding things
| Command | Description |
| ---- | ------- |
| `<space>pv` | WHILE IN FILE: Return to `netrw`. Same as using `:Ex`. |
| `<space>pf` | Your go-to file finder (with previews!) This is how you switch between files while working on your project. Much faster than using a file tree. |
| `<space>ps` | Your go-to text finder (with previews!) If you need to find where you put the `supercalifragilisticexpialidocious()` function, this will help a lot. |
| `[t`, `]t` | Jump between labelled comments (e.g. `// TODO`) |
| `[d`, `]d` | Jump between diagnostics (errors, warnings, info; provided by the LSP). |

### Doing stuff to things (Requires compatible LSP)
While in a supported source file and with your cursor over a compatible object (vars, functions, types, etc):
| Command | Description |
| ---- | ------- |
| `Shift-k` | View information about selected object (same as hovering over it with your mouse in other IDEs). |
| `<space>f` | Auto-format the current buffer. |
| `<space>vrr` | Find references of selected object across all files in `pwd`. |
| `<space>vrn` | Find and rename all references of selected object across all files in `pwd`. |
| `<space>gd` | Go to definition of selected object. |
| `<space>vca` | Code actions. What this does entirely depends on your LSP. I usually use it for organizing imports or filling structs in Go. |

### Moving yourself around
| Command | Description |
| ---- | ------- |
| `<Ctrl-o>` | Move back to where you were a moment ago. |
| `<Ctrl-i>` | Does the same as above, but in reverse! |
| `<Ctrl-u>` | Goes up by half a page. |
| `<Ctrl-d>` | Goes down by half a page. |

### Moving stuff around
| Command | Description |
| ---- | ------- |
| `<Shift-j>` | NORMAL MODE: Brings the next line to the end of the current line. |
| `<Shift-j>` | VISUAL LINE MODE: Move currently selected text down by 1 line. |
| `<Shift-k>` | VISUAL LINE MODE: Move currently selected text up by 1 line. |

### Extra context
These things are somewhat experimantal. They may randomly break or refuse to work.
* To copy to system clipboard, select the text in visual mode (Shift-v for visual line mode) and use `<space>y`. To paste something from your system clipboard, use `<space>p`.
* To delete something without sending it to the default register (which would overwrite your currently yanked/cut line) use `<space>d`.
