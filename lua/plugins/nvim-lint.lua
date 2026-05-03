local function in_workflows(ctx)
  return vim.fs.normalize(ctx.filename):find("/%.github/workflows/") ~= nil
end

return {
  "mfussenegger/nvim-lint",
  opts = {
    linters_by_ft = {
      yaml = { "actionlint", "zizmor" },
    },
    linters = {
      -- The bundled zizmor parser asserts on Low/Informational severities.
      zizmor = {
        prepend_args = { "--min-severity", "medium" },
        condition = in_workflows,
      },
      actionlint = { condition = in_workflows },
    },
  },
}
