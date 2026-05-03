return {
  "nvim-lspconfig",
  opts = {
    inlay_hints = { enabled = false },
    servers = {
      ruff = {
        capabilities = {
          general = {
            -- positionEncodings = { "utf-8", "utf-16", "utf-32" }  <--- this is the default
            positionEncodings = { "utf-16" },
          },
        },
        on_attach = function(client, bufnr)
          LazyVim.format.register({
            name = "ruff.organize_imports",
            priority = 50,
            primary = false,
            format = function(bufnr_attached)
              if bufnr == bufnr_attached then
                vim.lsp.buf.code_action({
                  context = {
                    only = { "source.organizeImports" },
                    diagnostics = {},
                  },
                  apply = true,
                })
              end
              vim.wait(15)
            end,
            sources = function(_)
              return { "ruff.organize_imports" }
            end,
          })
        end,
      },
      pyright = {
        settings = {
          pyright = {
            disableTaggedHints = true,
          },
        },
      },
    },
  },
}
