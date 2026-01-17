# Installation
Run this command to check if you have a `~/.config` directory:
```bash
ls -a ~ | grep \\.config
```

If you DON'T have a `~/.config` directory:
```bash
cd ~ && git clone -b linux --depth 1 https://github.com/33313/.dotfiles.git .config && cd .config && rm -rf .git
# You may either install everything (recommended) or skip Go, C, Python, etc.
# For more info use: make help
make all
```

If you DO have a `~/.config` directory: 
```bash
cd ~ && git clone -b linux --depth 1 https://github.com/33313/.dotfiles.git
cd .dotfiles && rm -rf .git && cp -r ./* ~/.config && cd ~ && rm -rf .dotfiles && cd .config
# You may either install everything (recommended) or skip Go, C, Python, etc.
# For more info use: make help
make all
```

# Managing your configuration
## Version tracking
I highly recommend that you version track your dotfiles with git.
```bash
cd ~/.config
git init
git status # Check if you aren't adding anything you don't want to track and add it to the .gitignore file.
git add . && git commit -m "init"
```

> [!TIP]
> Push your changes to a public repository like GitHub, Gitlab, or similar.
> That way your dotfiles are always available and ready to go, wherever you are.

When you make changes to your configuration, commit them with `git add . && git commit -m "feat(thing): add joy and happiness"`. This helps prevent hours of debugging a newly updated, broken configuration.

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
To add a new theme, first find one that is compatible with Neovim (usually denoted by `.nvim` in its name). Then:
1. Open `nvim/lua/plugins/colors.lua`.
2. In the `return` statement near the bottom, add a new item to the list: `{ "greg/myawesometheme.nvim" },`.
3. Save the file.
4. Open `nvim/init.lua` and change `setTheme("some_theme_here")` to `setTheme("gregs_awesome_theme")`. Obviously, the actual names will vary and should be provided in the README of the theme you are installing.
5. That's it! Restart your Neovim and enjoy your new theme.

To remove a theme, open `nvim/lua/plugins/colors.lua` and remove anything you don't like, then save the file.

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
