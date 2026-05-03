return {
  "folke/trouble.nvim",
  opts = {
    -- don't let any mode auto-open
    modes = {
      diagnostics = { auto_open = false },
      quickfix = { auto_open = false }, -- the :Trouble quickfix view
      -- add others you use, e.g. "symbols", etc., if needed
    },
  },
}
