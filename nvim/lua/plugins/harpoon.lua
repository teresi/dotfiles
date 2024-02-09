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

    vim.keymap.set("n", "<C-1>", function() ui.nav_file(1) end)
    vim.keymap.set("n", "<C-2>", function() ui.nav_file(2) end)
    vim.keymap.set("n", "<C-3>", function() ui.nav_file(3) end)
    vim.keymap.set("n", "<C-4>", function() ui.nav_file(4) end)
  end
}
