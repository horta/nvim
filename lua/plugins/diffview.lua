return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
  keys = {
    { "<leader>gD", "<cmd>DiffviewOpen<cr>", desc = "Diffview" },
    { "<leader>gp", "<cmd>DiffviewOpen origin/main...HEAD<cr>", desc = "Diffview PR review (vs origin/main)" },
    { "<leader>gH", "<cmd>DiffviewFileHistory %<cr>", desc = "File history (Diffview)" },
  },
  opts = {},
  config = function(_, opts)
    require("diffview").setup(opts)

    -- Diffview has no option to hide the per-file "+N, -M" diff stats in the
    -- file panel, so conceal them for a cleaner sidebar. The stats are always
    -- rendered at end of line as ` <additions>, <deletions>`.
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "DiffviewFiles",
      callback = function()
        vim.opt_local.conceallevel = 2
        vim.opt_local.concealcursor = "nvic"
        vim.fn.matchadd("Conceal", [[ \d\+, \d\+\s*$]], 10, -1, { conceal = "" })
      end,
    })
  end,
}
