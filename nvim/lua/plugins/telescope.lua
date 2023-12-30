return {
  'nvim-telescope/telescope.nvim', tag = '0.1.5',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'BurntSushi/ripgrep',
  },
  config = function()
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files, {})  --find files
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})   --find via grep
    vim.keymap.set('n', '<leader>fb', builtin.buffers, {})     --find in existing buffer
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})   --find in tags
    vim.keymap.set('n', '<leader>f?', builtin.oldfiles, {})    --find recently opened
    vim.keymap.set('n', '<leader>fw', builtin.grep_string, {}) --find current word
    require('telescope').load_extension('fzf')
  end
}
