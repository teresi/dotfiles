-- view tags (e.g. ctags)
return {
  'preservim/tagbar',
  config = function()
    vim.keymap.set('n', '<F8>', ":Tagbar Toggle<CR>")
  end
}
