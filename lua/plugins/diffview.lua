return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
  keys = {
    { "<leader>gD", "<cmd>DiffviewOpen<cr>", desc = "Diffview" },
    { "<leader>gp", "<cmd>DiffviewOpen origin/main...HEAD<cr>", desc = "Diffview PR review (vs origin/main)" },
    { "<leader>gH", "<cmd>DiffviewFileHistory %<cr>", desc = "File history (Diffview)" },
  },
  opts = {},
}
