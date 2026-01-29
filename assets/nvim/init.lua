--      s                                          .x+=:.      .
--     :8                                         z`    ^%    @88>
--    .88                  .u    .                   .   <k   %8P
--   :888ooo      .u     .d88B :@8c       .u       .@8Ned8"    .
-- -*8888888   ud8888.  ="8888f8888r   ud8888.   .@^%8888"   .@88u
--   8888    :888'8888.   4888>'88"  :888'8888. x88:  `)8b. ''888E`
--   8888    d888 '88%"   4888> '    d888 '88%" 8888N=*8888   888E
--   8888    8888.+"      4888>      8888.+"     %8"    R88   888E
--  .8888Lu= 8888L       .d888L .+   8888L        @8Wou 9%    888E
--  ^%888*   '8888c. .+  ^"8888*"    '8888c. .+ .888888P`     888&
--    'Y"     '88888%       'Y'       '88888%   `   ^"F       R888"
--              'YP'                    'YP'                   ''

--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- TODO: add codelldb / dap for rustaceanvim
-- TODO: add additional treesitter plugins (see bottom of treesitter.lua)
-- TODO: clean up this file

require("config.options") -- loads lua/config/options.lua
require("config.keymaps") -- loads lua/config/keymaps.lua
require("config.commands") -- loads lua/config/commands.lua

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		lazyrepo,
		lazypath,
	})
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- the returned table will be merged and passed to setup
--require("lazy").setup("plugins")  -- loads all plugins in lua/plugins/*lua

-- NOTE: require `plugins.*` manually instead of just `plugins`
-- so we can turn off a plugin without moving it
require("lazy").setup({
	--require("plugins.adwaita"),
	require("plugins.autocomplete"),
	require("plugins.autopairs"),
	require("plugins.bclose"),
	--require("plugins.catppuccin"),
	--require("plugins.citruszest"),
	require("plugins.cokeline"),
	require("plugins.colorizer"),
	require("plugins.conform"),
	require("plugins.debug"),
	require("plugins.doge"),
	require("plugins.gitsigns"),
	require("plugins.guess_indent"),
	--require("plugins.heraldish"),
	require("plugins.indent_line"),
	require("plugins.lazydev"),
	require("plugins.lint"),
	require("plugins.lsp-config"),
	require("plugins.lualine"),
	require("plugins.mason_update_all"),
	--require("plugins.midnight"),
	require("plugins.mini"),
	require("plugins.moonfly"),
	require("plugins.neogen"),
	require("plugins.neo-tree"),
	--require("plugins.oxocarbon"),
	--require("plugins.rosepine"),
	require("plugins.rustacean"),
	require("plugins.telescope"),
	--require("plugins.themery"),
	require("plugins.todo-comments"),
	--require("plugins.tokyonight"),
	require("plugins.treesitter"),
	require("plugins.vim-startuptime"),
	require("plugins.whichkey"),
})

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
--require('lazy').setup({
-- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
-- NOTE: Plugins can also be added by using a table,
-- with the first argument being the link and the following
-- keys can be used to configure plugin behavior/loading/etc.
--
-- Use `opts = {}` to automatically pass options to a plugin's `setup()` function, forcing the plugin to be loaded.
--

-- Alternatively, use `config = function() ... end` for full control over the configuration.
-- If you prefer to call `setup` explicitly, use:
--    {
--        'lewis6991/gitsigns.nvim',
--        config = function()
--            require('gitsigns').setup({
--                -- Your gitsigns configuration here
--            })
--        end,
--    }
--
-- NOTE: Plugins can specify dependencies.
--
-- The dependencies are proper plugin specifications as well - anything
-- you do for a plugin at the top level, you can do for a dependency.
--
-- Use the `dependencies` key to specify the dependencies of a particular plugin

-- The following comments only work if you have downloaded the kickstart repo, not just copy pasted the
-- init.lua. If you want these files, they are in the repository, so you can just download them and
-- place them in the correct locations.

-- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
--
--  Here are some example plugins that I've included in the Kickstart repository.
--  Uncomment any of the lines below to enable them (you will need to restart nvim).
--
-- require 'kickstart.plugins.debug',
-- require 'kickstart.plugins.indent_line',
-- require 'kickstart.plugins.lint',
-- require 'kickstart.plugins.autopairs',
-- require 'kickstart.plugins.neo-tree',
-- require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps

-- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
--    This is the easiest way to modularize your config.
--
--  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
-- { import = 'custom.plugins' },
--
-- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
-- Or use telescope!
-- In normal mode type `<space>sh` then write `lazy.nvim-plugin`
-- you can continue same window with `<space>sr` which resumes last telescope search
--}, {
--    ui = {
--        -- If you are using a Nerd Font: set icons to an empty table which will use the
--        -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
--        icons = vim.g.have_nerd_font and {} or {
--            cmd = '⌘',
--            config = '🛠',
--            event = '📅',
--            ft = '📂',
--            init = '⚙',
--            keys = '🗝',
--            plugin = '🔌',
--            runtime = '💻',
--            require = '🌙',
--            source = '📄',
--            start = '🚀',
--            task = '📌',
--            lazy = '💤 ',
--        },
--    },
--})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
--
