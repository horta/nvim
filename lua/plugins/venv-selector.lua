return {
  "linux-cultist/venv-selector.nvim",
  cmd = "VenvSelect",
  opts = {
    options = {
      notify_user_on_venv_activation = false,
    },
    search = {
      virtualenvs = false,
      hatch = false,
      poetry = false,
      pyenv = false,
      pipenv = false,
      anaconda_envs = false,
      anaconda_base = false,
      miniconda_envs = false,
      miniconda_base = false,
      pipx = false,
      -- cwd = false,
      -- workspace = false,
      -- file = false,
    },
  },
  --  Call config for Python files and load the cached venv automatically
  ft = "python",
  keys = { { "<leader>cv", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv", ft = "python" } },
}
