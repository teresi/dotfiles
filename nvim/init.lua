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

require("user.options")            -- my settings
require("user.keymaps")            -- my mappings


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
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})



-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
--local capabilities = vim.lsp.protocol.make_client_capabilities()
--capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
--local mason_lspconfig = require 'mason-lspconfig'
--
--mason_lspconfig.setup {
--  ensure_installed = vim.tbl_keys(servers),
--}
--
--mason_lspconfig.setup_handlers {
--  function(server_name)
--    require('lspconfig')[server_name].setup {
--      capabilities = capabilities,
--      on_attach = on_attach,
--      settings = servers[server_name],
--    }
--  end,
--}

-- nvim-cmp setup
--local cmp = require 'cmp'
--local luasnip = require 'luasnip'
--luasnip.config.setup {}

--cmp.setup {
--  snippet = {
--    expand = function(args)
--      luasnip.lsp_expand(args.body)
--    end,
--  },
--  mapping = cmp.mapping.preset.insert {
--    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
--    ['<C-f>'] = cmp.mapping.scroll_docs(4),
--    ['<C-Space>'] = cmp.mapping.complete {},
--    ['<CR>'] = cmp.mapping.confirm {
--      behavior = cmp.ConfirmBehavior.Replace,
--      select = true,
--    },
--    ['<Down>'] = cmp.mapping(function(fallback)
--      if cmp.visible() then
--        cmp.select_next_item()
--      elseif luasnip.expand_or_jumpable() then
--        luasnip.expand_or_jump()
--      else
--        fallback()
--      end
--    end, { 'i', 's' }),
--    ['<Up>'] = cmp.mapping(function(fallback)
--      if cmp.visible() then
--        cmp.select_prev_item()
--      elseif luasnip.jumpable(-1) then
--        luasnip.jump(-1)
--      else
--        fallback()
--      end
--    end, { 'i', 's' }),
--  },
--  sources = {
--    { name = 'nvim_lsp' },
--    { name = 'luasnip' },
--  },
--}

