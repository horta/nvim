return {
  "wincent/scalpel",
  keys = { { "<leader>l", "<Plug>(Scalpel)", desc = "Rep[l]ace Word" } },
  config = function()
    vim.cmd([[ let g:ScalpelMap=0 ]])
  end,
}
