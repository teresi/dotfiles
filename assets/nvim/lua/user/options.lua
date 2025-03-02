-- [[ Setting options ]]
-- See `:help vim.o`

-- SEE  https://github.com/LunarVim/nvim-basic-ide/blob/master/lua/options.lua


-- [[ clipboard ]]
vim.opt.clipboard = 'unnamedplus'  -- sync clipboard between OS and nvim


-- [[ UI ]]
vim.opt.termguicolors = true       -- true color support (24bit)
vim.opt.number = true              -- show line numbers
vim.opt.relativenumber = true      -- show line number relative to current line
vim.opt.cursorline = true          -- highlight current line
vim.opt.breakindent = true         -- wrapped lines are visually indented
vim.opt.undofile = true            -- persistent undo history
vim.opt.hlsearch = true            -- highlight matches on search
vim.opt.ignorecase = true          -- ignorecase when searching
vim.opt.smartcase = true           -- override ignorecase if pattern has uppercase
vim.opt.signcolumn = 'yes'         -- show lint/debug signs on left hand side
vim.opt.list = true                -- visualize trailing whitespace
vim.opt.listchars = {
    trail = '·',
    tab = '¦ ',
    precedes = '«',
    extends = '»',
}
vim.opt.fillchars = {              -- window separators
    horiz = '─',
    horizup = '┴',
    horizdown = '┬',
    vert = '|',
    vertleft = '┤',
    vertright = '├',
    verthoriz = '┼',
}
vim.api.nvim_set_hl(               -- window separator color
    0,
    'WinSeparator',
    { fg = '#FFFF5F'}
)


-- [[ tabs vs spaces ]]
vim.opt.expandtab = true           -- use spaces not tabs
vim.opt.shiftwidth = 4             -- shift 4 spaces on tab
vim.opt.tabstop = 4                -- number spaces a tab displays for
vim.opt.smartindent = true         -- autoindent on new lones


-- [[ Human Interface Devices ]]
vim.g.mapleader = ' '              -- <space> as leader key (set before lazy)
vim.g.maplocalleader = ' '         -- <space> as leader key (set before lazy)
vim.opt.mouse = 'a'                -- enable mouse
vim.opt.clipboard = 'unnamedplus'  -- sync clipboard between OS and nvim
vim.opt.timeout = true             -- wait `ttimeoutlen` after recieving ESC for another key
vim.opt.timeoutlen = 300           -- ms to wait for a mapped sequence to complete (default 1000)


-- [[ CPU / memory ]]
vim.opt.hidden = true              -- enable background buffers
vim.opt.updatetime = 2000          -- period to write swap file (default 4000)
vim.opt.lazyredraw = true          -- faster scroll
vim.opt.synmaxcol = 1024           -- max col for syntax highlight (default 3000)


-- Set completeopt to have a better completion experience
vim.opt.completeopt = 'menuone,noselect'

