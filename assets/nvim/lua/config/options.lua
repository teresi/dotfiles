-- [[ Setting options ]]
-- See `:help vim.o`

-- SEE  https://github.com/LunarVim/nvim-basic-ide/blob/master/lua/options.lua

-- [[ UI ]]
vim.opt.termguicolors = true -- true color support (24bit)
vim.cmd.colorscheme("wildcharm")
vim.opt.number = true -- show line numbers
vim.opt.relativenumber = true -- show line number relative to current line
vim.opt.cursorline = true -- highlight current line
vim.opt.breakindent = true -- wrapped lines are visually indented
vim.opt.undofile = true -- persistent undo history
vim.opt.hlsearch = true -- highlight matches on search
vim.opt.ignorecase = true -- ignorecase when searching
vim.opt.smartcase = true -- override ignorecase if pattern has uppercase
vim.opt.signcolumn = "yes" -- show lint/debug signs on left hand side
vim.opt.list = true -- visualize trailing whitespace
vim.opt.listchars = {
	trail = "·",
	tab = "¦ ",
	precedes = "«",
	extends = "»",
}
vim.opt.fillchars = { -- window separators
	horiz = "─",
	horizup = "┴",
	horizdown = "┬",
	vert = "|",
	vertleft = "┤",
	vertright = "├",
	verthoriz = "┼",
}
vim.api.nvim_set_hl( -- window separator color
	0,
	"WinSeparator",
	{ fg = "#FFFF5F" }
)
vim.api.nvim_set_hl( -- fill for non-buffer space in cokeline
	0,
	"TabLineFill",
	{ fg = "#000000" }
)
vim.api.nvim_set_hl( -- background to folded lines
	0,
	"Folded",
	{ bg = "#000000" }
)

-- [[ tabs vs spaces ]]
vim.opt.expandtab = true -- use spaces not tabs
vim.opt.shiftwidth = 4 -- shift 4 spaces on tab
vim.opt.tabstop = 4 -- number spaces a tab displays for
vim.opt.smartindent = true -- autoindent on new lones

-- [[ Human Interface Devices ]]
vim.opt.mouse = "a" -- enable mouse
vim.opt.timeout = true -- wait `ttimeoutlen` after recieving ESC for another key
vim.opt.timeoutlen = 300 -- ms to wait for a mapped sequence to complete (default 1000)

-- [[ CPU / memory ]]
vim.opt.hidden = true -- enable background buffers
vim.opt.updatetime = 1000 -- period to write swap file (default 4000)
vim.opt.lazyredraw = true -- faster scroll
vim.opt.synmaxcol = 1024 -- max col for syntax highlight (default 3000)

-- ---------kickstart:

-- Set completeopt to have a better completion experience
vim.opt.completeopt = "menuone,noselect"

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

vim.g.loaded_netrw = 1 -- disable netrw at start of init.lua
vim.g.loaded_netrwPlugin = 1 -- disable netrw at start of init.lua

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Preview substitutions live, as you type!
vim.o.inccommand = "split"

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 8

-- [[ folding ]]
-- NOTE: folding is set in treesitter.lua but needed these settings here
vim.opt.foldlevel = 005 -- starting fold (0 means all levels are folded)
vim.opt.foldnestmax = 5 -- max level to close, treat as one chunk

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

vim.cmd([[
augroup MyColors
autocmd!
autocmd ColorScheme * highlight Folded guibg=#0F0000
augroup end
]])

-- [[ spell check ]]
vim.opt.spelllang = "en_US"
