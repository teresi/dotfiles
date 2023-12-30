-- view tags (e.g. ctags)
return {
  'preservim/tagbar',
  config = function()
    vim.keymap.set('n', '<F3>', ":Tagbar Toggle<CR>")
  end
}
