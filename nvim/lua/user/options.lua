
-- SEE  https://github.com/LunarVim/nvim-basic-ide/blob/master/lua/options.lua
--
vim.opt.number = number          -- show line numbers
vim.opt.relativenumber = true    -- show line number relative to current line
vim.opt.cursorline = true        -- highlight current line


vim.opt.titlestring = [[%f %h%m%r%w %{v:progname} (%{tabpagenr()} of %{tabpagenr('$')})]]
vim.opt.hlsearch = true

vim.opt.termguicolors = true     -- set termguicolors to enable highlight groups

