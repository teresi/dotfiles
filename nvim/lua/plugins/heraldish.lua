return {
  'petobens/colorish',
  priority = 1000,
  config = function()
    vim.cmd.colorscheme 'heraldish'
    vim.cmd.highlight 'cursorline guibg=#000000'
    vim.cmd.highlight 'LineNR guibg=#000000'
    vim.cmd.highlight 'CursorLineNr guifg=yellow'
    vim.cmd.hi        'Comment ctermfg=243 guifg=#626262'
  end,
}
