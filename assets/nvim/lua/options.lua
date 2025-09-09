local opt = vim.opt
local o = vim.o
local g = vim.g

-------------------------------------- options, nvchad ------------------------------------------
o.showmode = false
o.splitkeep = "screen"

-- Numbers
o.laststatus = 3
o.ruler = true

-- disable nvim intro
opt.shortmess:append "sI"

o.splitbelow = true
o.splitright = true

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append "<>[]hl"

-- disable some default providers
g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

-- add binaries installed by mason.nvim to path
local is_windows = vim.fn.has "win32" ~= 0
local sep = is_windows and "\\" or "/"
local delim = is_windows and ";" or ":"
vim.env.PATH = table.concat({ vim.fn.stdpath "data", "mason", "bin" }, sep) .. delim .. vim.env.PATH


-------------------------------------- options, custom ------------------------------------------

-- [[ clipboard ]]
vim.opt.clipboard = 'unnamedplus'  -- sync clipboard between OS and nvim


-- [[ UI ]]
vim.opt.termguicolors = true       -- true color support (24bit)
vim.opt.number = true              -- show line numbers
vim.opt.numberwidth = 2            -- minimum width of number column
vim.opt.relativenumber = true      -- show line number relative to current line
vim.opt.cursorline = true          -- highlight current line
vim.opt.cursorlineopt = "both"     -- highlight current line via the text line and line number
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
vim.opt.softtabstop = 4            -- number of spaces to add/delete a tab
vim.opt.smartindent = true         -- autoindent on new lones


-- [[ Human Interface Devices ]]
vim.opt.mouse = 'a'                -- enable mouse
vim.opt.clipboard = 'unnamedplus'  -- sync clipboard between OS and nvim
vim.opt.timeout = true             -- wait `ttimeoutlen` after recieving ESC for another key
vim.opt.timeoutlen = 300           -- ms to wait for a mapped sequence to complete (default 1000)


-- [[ CPU / memory ]]
vim.opt.hidden = true              -- enable background buffers
vim.opt.updatetime = 1000          -- period to write swap file (default 4000) (also used by gitsigns)
vim.opt.lazyredraw = true          -- faster scroll
vim.opt.synmaxcol = 1024           -- max col for syntax highlight (default 3000)


-- Set completeopt to have a better completion experience
vim.opt.completeopt = 'menuone,noselect'


-- nvtree, don't ask which window to open a file in
-- TODO move back to old file system viewer
--require('nvim-tree').setup({ actions = { open\_file = { window\_picker = { enable = false } } } })
