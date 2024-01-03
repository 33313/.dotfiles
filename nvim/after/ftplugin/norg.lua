local colorscheme = "kanagawa"
local ok, _ = pcall(vim.api.nvim_command, "colorscheme " .. colorscheme)
if not ok then
  print("error setting colorscheme")
end

vim.opt_local.wrap = true
vim.opt_local.linebreak = true
