vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.cmd([[set ignorecase smartcase]])

vim.opt.termguicolors = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOMEPATH") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

-- I LOOOOOOVE FILESYSTEMS 😻😻😻
vim.opt.isfname = "@,48-57,/,\\,.,-,_,+,,,#,$,%,:,@-@,!,~,="

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

-- Python3 provider
vim.g.python3_host_prog = os.getenv("HOMEPATH") .. "/.local/venv/nvim/Scripts/python"
