return {
  "nvim-neotest/neotest",
  optional = true,
  dependencies = {
    "nvim-neotest/neotest-python",
  },
  keys = {
    {
      "<leader>ta",
      function()
        require("neotest").run.attach()
      end,
      desc = "Neotest: attach to running test",
      mode = "n",
    },
  },

  opts = function(_, opts)
    opts = opts or {}

    -- don't auto-open any Neotest output window
    opts.output = vim.tbl_deep_extend("force", opts.output or {}, {
      open_on_run = false,
    })

    -- keep filling quickfix, but NEVER open it automatically (or Trouble)
    opts.quickfix = {
      enabled = true,
      open = function() end, -- override LazyVim's default opener
    }

    -- your adapter settings
    opts.adapters = opts.adapters or {}
    opts.adapters["neotest-python"] = vim.tbl_deep_extend("force", opts.adapters["neotest-python"] or {}, {
      -- args = { "--no-cov" },
      -- runner = "pytest",
      -- python = ".venv/bin/python",
    })

    return opts
  end,
}
