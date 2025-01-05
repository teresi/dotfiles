--     s                                          .x+=:.      .
--    :8                                         z`    ^%    @88>
--   .88                  .u    .                   .   <k   %8P
--  :888ooo      .u     .d88B :@8c       .u       .@8Ned8"    .
---*8888888   ud8888.  ="8888f8888r   ud8888.   .@^%8888"   .@88u
--  8888    :888'8888.   4888>'88"  :888'8888. x88:  `)8b. ''888E`
--  8888    d888 '88%"   4888> '    d888 '88%" 8888N=*8888   888E
--  8888    8888.+"      4888>      8888.+"     %8"    R88   888E
-- .8888Lu= 8888L       .d888L .+   8888L        @8Wou 9%    888E
-- ^%888*   '8888c. .+  ^"8888*"    '8888c. .+ .888888P`     888&
--   'Y"     '88888%       'Y'       '88888%   `   ^"F       R888"
--             'YP'                    'YP'                   ''


vim.g.loaded_netrw = 1             -- NB disable netrw at start of init.lua
vim.g.loaded_netrwPlugin = 1       -- NB disable netrw at start of init.lua
vim.opt.termguicolors = true       -- true color support (24bit)

vim.filetype.add({ extension = { pyx = 'python' } })  -- cython files are mis-identified as pyrex


require("user.options")            -- sundry vim.opt calls
require("user.keymaps")            -- sundry vim.keymap calls


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
require('lazy').setup("plugins")   -- initialize plugins


--vim.opt.clipboard = require('deferred-clipboard')  -- sync clipboard between OS and nvim
vim.opt.clipboard = 'unnamedplus'  -- sync clipboard between OS and nvim



-- [[ append $PWD to path on startup ]]
-- fix for issue where `:find` can't find files in $PWD
local group_cdpwd = vim.api.nvim_create_augroup("group_cdpwd", { clear = true })
vim.api.nvim_create_autocmd("VimEnter", {
  group = group_cdpwd,
  pattern = "*",
  callback = function()
    vim.opt.path:append '**'
  end,
})


-- [[ Highlight on yank ]]
-- see `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ remove trailing whitespace ]]
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = {"*"},
    callback = function()
      local save_cursor = vim.fn.getpos(".")
      pcall(function() vim.cmd [[%s/\s\+$//e]] end)
      vim.fn.setpos(".", save_cursor)
    end,
})

-- [[ update Mason from command line ]]
-- nvim --headless -c 'autocmd User MasonUpdateAllComplete quitall' -c 'MasonUpdateAll'
vim.api.nvim_create_autocmd('User', {
    pattern = 'MasonUpdateAllComplete',
    callback = function()
        print('\nmason-update-all has finished\n\n')
    end,
})
