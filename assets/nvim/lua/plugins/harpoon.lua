return {
  'ThePrimeagen/harpoon',
  config = function()
    require("telescope").load_extension('harpoon')
    require("harpoon").setup{
      -- set marks specific to each git branch inside git repository
      mark_branch = false,
    }
    local mark = require("harpoon.mark")
    vim.keymap.set('n', '<leader>ha', mark.add_file)
    vim.keymap.set('n', '<leader>hr', mark.rm_file)

    local ui = require("harpoon.ui")
    vim.keymap.set('n', '<leader>hn', ui.nav_next)
    vim.keymap.set('n', '<leader>hp', ui.nav_prev)
    vim.keymap.set('n', '<leader>hm', ui.toggle_quick_menu)
    vim.keymap.set('n', '<leader>tm', require("telescope").extensions.harpoon.marks)

      -- C-1, C-2, C-3, C-4 work in nvim/alacritty, but not when inside tmux
      -- still looking into this functionality, see extended keys
    vim.keymap.set("n", "<C-1>", function() ui.nav_file(1) end)
    vim.keymap.set("n", "<C-2>", function() ui.nav_file(2) end)
    vim.keymap.set("n", "<C-3>", function() ui.nav_file(3) end)
  end
}
