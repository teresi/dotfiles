return {
  -- run git commands
  {'tpope/vim-fugitive'},

  -- close using :Bclose or <leader>bd
  {'rbgrouleff/bclose.vim'},

  -- detect tabstop and shiftwidth automatically
  {'tpope/vim-sleuth'},

  -- lua lsp and nvim dev
  {"folke/neodev.nvim", opts = {} },

  -- profile startup
  {"dstein64/vim-startuptime"},

  -- :Rename, :Trash, :Move, etc functions
  {"chrisgrieser/nvim-genghis", dependencies = "stevearc/dressing.nvim"},

  -- display and remove trailing whitespace
  --{'johnfrankmorgan/whitespace.nvim'},
  --
  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

}
