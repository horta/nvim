-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.python3_host_prog = "/Users/horta/.pyenv/versions/3.12.7/bin/python3"
vim.g.autoformat = false
vim.o.relativenumber = false
-- vim.cmd([[autocmd FileType c setlocal colorcolumn=80]])
-- vim.cmd([[autocmd FileType cpp setlocal colorcolumn=80]])
-- vim.cmd([[autocmd FileType python setlocal colorcolumn=89]])
vim.cmd([[hi clear NormalNC]])
-- vim.cmd([[autocmd TermOpen * setlocal nonumber norelativenumber]])
vim.api.nvim_set_hl(0, "@string.special.url", { underline = false })
vim.g.lazyvim_python_lsp = "pyright"
