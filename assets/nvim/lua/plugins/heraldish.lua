-- NOTE petobens/colorish uses #1C1B1A as 'gray' backgroud
--      _but_ herald uses #1C1C1C
return {
  'petobens/colorish',
  priority = 1000,
  init = function()
    vim.cmd.colorscheme 'heraldish'
    vim.cmd.highlight 'cursorline guibg=#000000'
    vim.cmd.highlight 'LineNR guibg=#000000'
    vim.cmd.highlight 'CursorLineNr guifg=yellow'
    vim.cmd.highlight 'CursorLineNr guibg=#000000'
    vim.cmd.highlight 'Comment ctermfg=243 guifg=#626262'
    vim.cmd.highlight 'SignColumn guibg=#1C1C1C'
  end,
}
