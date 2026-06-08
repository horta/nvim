return {
  "barrettruth/diffs.nvim",
  -- Config is read from vim.g.diffs once at plugin load; features attach via
  -- autocmds (diff mode, fugitive/gitsigns buffers), so load eagerly.
  lazy = false,
  init = function()
    vim.g.diffs = {
      integrations = {
        fugitive = true,
        gitsigns = true,
        neogit = false,
        telescope = true,
      },
      -- Conflict markers are handled by git-conflict.nvim (see conflict.lua).
      conflict = { enabled = false },
    }
  end,
}
