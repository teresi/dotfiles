return {
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NB: requires install of `make`
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'BurntSushi/ripgrep',
    },
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files,  {desc="find files"})
      vim.keymap.set('n', '<leader>fg', builtin.live_grep,   {desc="live grep"})
      vim.keymap.set('n', '<leader>fb', builtin.buffers,     {desc="find buffer"})
      vim.keymap.set('n', '<leader>fh', builtin.help_tags,   {desc="find tags"})
      vim.keymap.set('n', '<leader>f?', builtin.oldfiles,    {desc="find recently open"})
      vim.keymap.set('n', '<leader>fw', builtin.grep_string, {desc="find words"})
      vim.keymap.set('n', '<leader>fc', builtin.grep_string, {desc="find word under cursor"})
      require('telescope').load_extension('fzf')
    end
  },
}

