return {
  "haya14busa/vim-asterisk",
  config = function()
    local o = { noremap = true, silent = true }
    local kset = vim.keymap.set
    kset("n", "*", [[<Plug>(asterisk-z*)]], o)
    kset("n", "#", [[<Plug>(asterisk-z#)]], o)
    kset("n", "g*", [[<Plug>(asterisk-gz*)]], o)
    kset("n", "g#", [[<Plug>(asterisk-gz#)]], o)
    kset("x", "*", [[<Plug>(asterisk-z*)]], o)
    kset("x", "#", [[<Plug>(asterisk-z#)]], o)
    kset("x", "g*", [[<Plug>(asterisk-gz*)]], o)
    kset("x", "g#", [[<Plug>(asterisk-gz#)]], o)
    vim.cmd([[let g:asterisk#keeppos = 1]])
  end,
}
