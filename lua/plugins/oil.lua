return {
  "stevearc/oil.nvim",
  opts = {},
  cmd = "Oil",
  keys = {
    { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
    -- {
    --   "yp",
    --   function()
    --     local actions = require("oil.actions")
    --     actions.copy_entry_path.callback()
    --     vim.fn.setreg("+", vim.fn.getreg(vim.v.register))
    --   end,
    --   ft = "oil", -- ensure it only applies inside Oil buffer
    --   desc = "Copy filepath to system clipboard",
    -- },
    {
      "yp",
      function()
        local oil = require("oil")
        local entry = oil.get_cursor_entry()
        if not entry then
          return
        end
        local dir = oil.get_current_dir()
        if not dir then
          return
        end
        local abs_path = vim.fs.normalize(dir .. entry.name)

        -- find git root
        local git_root = vim.fn.systemlist("git -C " .. vim.fn.shellescape(abs_path) .. " rev-parse --show-toplevel")[1]
        if git_root and git_root ~= "" then
          local rel_path = vim.fn.fnamemodify(abs_path, ":." .. git_root)
          vim.fn.setreg("+", rel_path)
          print("Yanked relative path: " .. rel_path)
        else
          vim.fn.setreg("+", abs_path)
          print("Yanked absolute path (no git root found): " .. abs_path)
        end
      end,
    },
  },
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
