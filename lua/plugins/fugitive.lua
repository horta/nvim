return {
  "tpope/vim-fugitive",
  dependencies = {
    "tpope/vim-rhubarb",
  },
  config = function()
    local o = { noremap = true, silent = true }
    local kset = vim.keymap.set
    kset("n", "<leader>G", [[<cmd>:Git<CR>]], o)
  end,
}
