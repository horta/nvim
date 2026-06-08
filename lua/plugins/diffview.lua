return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
  keys = {
    { "<leader>gD", "<cmd>DiffviewOpen<cr>", desc = "Diffview" },
    { "<leader>gH", "<cmd>DiffviewFileHistory %<cr>", desc = "File history (Diffview)" },
  },
  opts = {},
}
