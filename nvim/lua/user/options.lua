-- [[ Setting options ]]
-- See `:help vim.o`

-- SEE  https://github.com/LunarVim/nvim-basic-ide/blob/master/lua/options.lua

vim.opt.termguicolors = true

vim.g.mapleader = ' '            -- <space> as leader key (set before lazy)
vim.g.maplocalleader = ' '       -- <space> as leader key (set before lazy)

vim.opt.number = true            -- show line numbers
vim.opt.relativenumber = true    -- show line number relative to current line
vim.opt.cursorline = true        -- highlight current line
--vim.cmd([[highlight LineNr guibg=black]])
--vim.cmd([[highlight CursorLineNr guifg=yellow]])



vim.opt.titlestring = [[%f %h%m%r%w %{v:progname} (%{tabpagenr()} of %{tabpagenr('$')})]]

vim.opt.hlsearch = true          -- highlight matches on search
vim.opt.termguicolors = true     -- set termguicolors to enable highlight groups

vim.opt.mouse = 'a'                -- enable mouse

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = 'unnamedplus'

vim.opt.breakindent = true         -- wrapped lines are visually indented

vim.opt.undofile = true            -- persistent undo history

-- Case insensitive searching UNLESS /C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = 'yes'          -- show lint/debug signs on left hand side

vim.opt.updatetime = 1000            -- period to write swap file (default 40000)

vim.opt.timeout = true               -- enable to wait `ttimeoutlen` after recieving ESC for another key

vim.opt.timeoutlen = 300             -- ms to wait for a mapped sequence to complete (default 1000)

-- Set completeopt to have a better completion experience
vim.opt.completeopt = 'menuone,noselect'
