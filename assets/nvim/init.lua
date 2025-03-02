require("config.options") -- loads lua/config/options.lua
require("config.keymaps") -- loads lua/config/keymaps.lua

-- [[ lazy package manager ]]
-- installs plugins at: plugins.lua, plugins/*.lua
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
-- loads lua/plugins/*.lua
-- the returned table will be merged and passed to setup
require('lazy').setup("plugins")


require("teresi")
