-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("c/c++-colorcolumn"),
  pattern = { "c", "cpp" },
  callback = function(_)
    vim.api.nvim_set_option_value("colorcolumn", "80", { scope = "local" })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("python-colorcolumn"),
  pattern = { "python" },
  callback = function(_)
    vim.api.nvim_set_option_value("colorcolumn", "89", { scope = "local" })
  end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  group = augroup("termopen-linenumbers"),
  pattern = { "*" },
  callback = function(_)
    vim.api.nvim_set_option_value("number", false, { scope = "local" })
    vim.api.nvim_set_option_value("relativenumber", false, { scope = "local" })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("horta_disable_hyperlink_underline", { clear = true }),
  pattern = {
    "*",
  },
  callback = function()
    vim.api.nvim_set_hl(0, "@string.special.url", { underline = false })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = false
  end,
})


vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = { "*" },
  callback = function()
    if vim.bo.filetype == "copilot-chat" then
      vim.opt_local.conceallevel = 0
      vim.opt_local.concealcursor = ""
    end
  end,
})

local function commit_buffer_is_empty(bufnr)
  bufnr = bufnr or 0

  -- Derive the comment leader from 'commentstring' (e.g. "# %s").
  local cs = vim.bo[bufnr].commentstring or "# %s"
  local leader = vim.trim(cs:gsub("%%s", "")) -- remove "%s" and trim
  local first = leader:sub(1, 1)
  if first == "" then
    first = "#"
  end -- fallback

  -- Escape for Lua patterns
  local esc = first:gsub("(%W)", "%%%1")

  for _, l in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
    if l:match("^%s*$") then
      -- blank: ignore
    elseif not l:match("^%s*" .. esc) then
      -- found a non-comment, non-blank line → buffer is NOT empty
      return false
    end
  end
  return true
end

local function to_string(ans)
  if type(ans) == "string" then
    return ans
  elseif type(ans) == "table" then
    -- Try common fields used by chat/message objects
    return ans.text or ans.content or ans.message or ans.body or ""
  else
    return tostring(ans or "")
  end
end

local function extract_commit_message(text)
  local start, finish
  local lines = vim.split(text, "\n", { plain = true })

  for i, l in ipairs(lines) do
    if not start and l:match("^%s*```%s*gitcommit") then
      start = i + 1 -- first line *inside* the block
    elseif start and l:match("^%s*```") then
      finish = i - 1 -- last line before closing fence
      break
    end
  end

  if start and finish and start <= finish then
    local slice = {}
    for i = start, finish do
      table.insert(slice, lines[i])
    end
    return vim.trim(table.concat(slice, "\n"))
  else
    return vim.trim(text) -- fallback
  end
end

local function window_for_buffer(bufnr)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == bufnr then
      return win
    end
  end
end

local function close_copilot_chat_windows()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local bufnr = vim.api.nvim_win_get_buf(win)
    local ft = vim.bo[bufnr].filetype
    if ft == "copilot-chat" then
      pcall(vim.api.nvim_win_close, win, true)
    end
  end
end

local function prepend_copilot_commit(bufnr)
  local cb = function(answer)
    if not vim.api.nvim_buf_is_valid(bufnr) then
      return
    end

    answer = to_string(answer)
    answer = extract_commit_message(answer)

    local lines = vim.split(vim.trim(answer), "\n", { plain = true })
    lines = vim.tbl_map(function(line)
      return vim.trim(line)
    end, lines)

    vim.api.nvim_buf_set_lines(bufnr, 0, 0, false, lines)
    local win = window_for_buffer(bufnr)
    if win then
      vim.api.nvim_set_current_win(win)
      vim.cmd("stopinsert")
      vim.api.nvim_win_set_cursor(win, { 1, 0 })
    end
    vim.schedule(close_copilot_chat_windows)
  end

  local chat = require("CopilotChat")
  chat.ask(
    "Write commit message for the change with commitizen convention. Keep the title under 50 characters and wrap message at 72 characters. Format as a gitcommit code block.",
    { sticky = "#gitdiff:staged", callback = cb }
  )
end

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "COMMIT_EDITMSG",
  callback = function(args)
    if commit_buffer_is_empty(args.buf) then
      vim.schedule(function()
        prepend_copilot_commit(args.buf)
      end)
    end
  end,
})
