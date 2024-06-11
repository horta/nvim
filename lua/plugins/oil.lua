return {
  "stevearc/oil.nvim",
  opts = {},
  cmd = "Oil",
  keys = { { "-", "<cmd>Oil<cr>", desc = "Open parent directory" } },
  init = function()
    if vim.fn.argc() == 1 then
      local filename = tostring(vim.fn.argv(0))
      local stat = vim.loop.fs_stat(filename)
      if stat and stat.type == "directory" then
        require("lazy").load({ plugins = { "oil.nvim" } })
      end
    end
    if not require("lazy.core.config").plugins["oil.nvim"]._.loaded then
      vim.api.nvim_create_autocmd("BufNew", {
        callback = function()
          if vim.fn.isdirectory(vim.fn.expand("<afile>")) == 1 then
            require("lazy").load({ plugins = { "oil.nvim" } })
            -- Once oil is loaded, we can delete this autocmd
            return true
          end
        end,
      })
    end
  end,
}
