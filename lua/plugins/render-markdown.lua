return {
  "MeanderingProgrammer/render-markdown.nvim",
  opts = {
    code = {
      sign = false,
      width = "block",
      right_pad = 1,
    },
    heading = {
      sign = false,
      icons = {},
      conceal = false,     -- Don't hide Markdown heading markers
    },
    checkbox = {
      enabled = false,
    },
    anti_conceal = {
      enabled = false,
      level=0,
    },
    -- code = {
    --   sign = false,        -- No special symbol for code blocks
    --   width = "block",     -- Keeps original block width
    --   right_pad = 0,       -- Remove right padding for visual clarity
    -- },
    -- heading = {
    --   sign = false,        -- No extra icons or indicators
    --   icons = {},          -- No icons at all
    --   conceal = false,     -- Don't hide Markdown heading markers
    -- },
    -- bullet = {
    --   conceal = false,     -- Don't replace bullet characters
    -- },
    -- checkbox = {
    --   enabled = false,     -- Don't render checkboxes specially
    -- },
    -- quote = {
    --   conceal = false,     -- Keep `>` symbols visible
    -- },
    -- thematic = {
    --   conceal = false,     -- Keep --- or *** visible
    -- },
    -- table = {
    --   conceal = false,     -- Don’t replace pipes or separators
    -- },
    -- link = {
    --   conceal = false,     -- Show raw markdown link format
    -- },
    -- url = {
    --   conceal = false,     -- Don't change URLs
    -- },
    -- anti_conceal = {
    --   enabled = true,      -- Prevent Neovim from hiding anything
    -- },
  },
  ft = { "markdown", "norg", "rmd", "org", "codecompanion" },
  config = function(_, opts)
    require("render-markdown").setup(opts)
    require("render-markdown").disable()
    Snacks.toggle({
      name = "Render Markdown",
      get = function()
        return require("render-markdown.state").enabled
      end,
      set = function(enabled)
        local m = require("render-markdown")
        if enabled then
          m.enable()
        else
          m.disable()
        end
      end,
    }):map("<leader>um")
  end,
}
