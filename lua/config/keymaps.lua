-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- vim.keymap.set("", "<leader>f", function()
--   require("conform").format({ async = false, lsp_fallback = true })
-- end)
local Util = require("lazyvim.util")

vim.keymap.set({ "n", "v" }, "gf", function()
  Util.format({ force = true })
  local esc = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
  vim.api.nvim_feedkeys(esc, "x", false)
end, { desc = "Format" })

-- vim.keymap.set({ "" }, "<leader>cR", "<cmd>ClangdSwitchSourceHeader<cr>", { desc = "Switch Source/Header (C/C++)" })
vim.keymap.set({ "" }, "<leader>H", "<cmd>ClangdSwitchSourceHeader<cr>", { desc = "Switch Source/Header (C/C++)" })
vim.keymap.set({ "" }, "<c-x>", function()
  local bd = require("mini.bufremove").delete
  if vim.bo.modified then
    local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
    if choice == 1 then -- Yes
      vim.cmd.write()
      bd(0)
    elseif choice == 2 then -- No
      bd(0, true)
    end
  else
    bd(0)
  end
end, { desc = "Delete Buffer" })

-- local function set_snacks_scroll(enabled)
--   if _G.Snacks and _G.Snacks.scroll then
--     if enabled then
--       _G.Snacks.scroll.enable()
--     else
--       _G.Snacks.scroll.disable()
--     end
--     return
--   end
--   local ok, scroll = pcall(require, "snacks.scroll")
--   if ok then
--     if enabled then
--       scroll.enable()
--     else
--       scroll.disable()
--     end
--     return
--   end
-- end
--
-- local function plain_line_scroll(dir)
--   local n = vim.v.count1
--   set_snacks_scroll(false)
--   local key = vim.keycode(dir == "down" and "<C-e>" or "<C-y>")
--   vim.api.nvim_feedkeys(string.rep(key, n), "n", false) -- feed native keys, no remap
--   set_snacks_scroll(true)
-- end
--
-- vim.keymap.set("n", "<C-e>", function()
--   plain_line_scroll("down")
-- end, { desc = "Scroll window down 1 line (no animation)", silent = true })
-- vim.keymap.set("n", "<C-y>", function()
--   plain_line_scroll("up")
-- end, { desc = "Scroll window up 1 line (no animation)", silent = true })
--
-- Keep a tiny debounce timer so smooth scroll stays disabled while holding the key
local enable_timer ---@type uv_timer_t|nil

local function toggle_snacks_scroll(enable)
  -- Support both global and require() access patterns
  local scroll = (_G.Snacks and _G.Snacks.scroll)
    or (pcall(require, "snacks.scroll") and require("snacks.scroll"))
    or nil
  if not scroll then
    return
  end
  local ok = pcall(function()
    if enable then
      scroll.enable()
    else
      scroll.disable()
    end
  end)
  if not ok then
    -- ignore if plugin not ready
  end
end

local function temporarily_disable_scroll()
  toggle_snacks_scroll(false)
  if enable_timer then
    enable_timer:stop()
    enable_timer:close()
    enable_timer = nil
  end
  -- Re-enable shortly after the last press; adjust delay if you like
  enable_timer = vim.defer_fn(function()
    toggle_snacks_scroll(true)
    enable_timer = nil
  end, 50) -- ms
end

-- Helper to return a keycode from an expr mapping without remapping recursion
local function return_key(lhs)
  return vim.api.nvim_replace_termcodes(lhs, true, false, true)
end

-- Plain, no-animation 1-line scroll with perfect key repeat
vim.keymap.set("n", "<C-e>", function()
  temporarily_disable_scroll()
  return return_key("<C-e>")
end, { expr = true, silent = true, desc = "Scroll window down 1 line (no animation)" })

vim.keymap.set("n", "<C-y>", function()
  temporarily_disable_scroll()
  return return_key("<C-y>")
end, { expr = true, silent = true, desc = "Scroll window up 1 line (no animation)" })
