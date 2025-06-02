-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("c/c++-colorcolumn"),
  pattern = { "c", "cpp" },
  callback = function(_)
    vim.api.nvim_set_option_value("colorcolumn", "80", { scope = "local" })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("python-colorcolumn"),
  pattern = { "python" },
  callback = function(_)
    vim.api.nvim_set_option_value("colorcolumn", "89", { scope = "local" })
  end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  group = augroup("termopen-linenumbers"),
  pattern = { "*" },
  callback = function(_)
    vim.api.nvim_set_option_value("number", false, { scope = "local" })
    vim.api.nvim_set_option_value("relativenumber", false, { scope = "local" })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("horta_disable_hyperlink_underline", { clear = true }),
  pattern = {
    "*",
  },
  callback = function()
    vim.api.nvim_set_hl(0, "@string.special.url", { underline = false })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = false
  end,
})
