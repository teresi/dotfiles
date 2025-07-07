return {
  -- package manager for nvim
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  -- installs LSPs using mason
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "bashls",       -- BASH
          "docker_compose_language_service",
          "dockerls",
          "jsonls",
          "ltex",         -- LaTeX
          "texlab",       -- LateX
          "lua_ls",
          "pyright",
          "rust_analyzer",
          "taplo",        -- TOML
          "yamlls",
        },
      })
    end
  },
  -- allows nvim to communicate to the LSP
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig.pyright.setup({})
      lspconfig.rust_analyzer.setup({})
      lspconfig.bashls.setup({})
      lspconfig.lua_ls.setup({})
      lspconfig.texlab.setup({})
      lspconfig.ltex.setup({
        --these are the default filetypes for ltex minus 'markdown'
        filetypes = { "bib", "gitcommit", "org", "plaintex", "rst", "rnoweb", "tex", "pandoc", "quarto", "rmd", "context", "html", "xhtml", "mail" },
      })
      lspconfig.taplo.setup({})
      lspconfig.yamlls.setup({})
      lspconfig.jsonls.setup({})
      lspconfig.dockerls.setup({})
      lspconfig.docker_compose_language_service.setup({})
      require'lspconfig'.lua_ls.setup {
        on_init = function(client)
          local path = client.workspace_folders[1].name
          if not vim.loop.fs_stat(path..'/.luarc.json') and not vim.loop.fs_stat(path..'/.luarc.jsonc') then
            client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
              Lua = {
                runtime = {
                  -- Tell the language server which version of Lua you're using
                  -- (most likely LuaJIT in the case of Neovim)
                  version = 'LuaJIT'
                },
                -- Make the server aware of Neovim runtime files
                workspace = {
                  checkThirdParty = false,
                  library = {
                    vim.env.VIMRUNTIME
                    -- "${3rd}/luv/library"
                    -- "${3rd}/busted/library",
                  }
                  -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                  -- library = vim.api.nvim_get_runtime_file("", true)
                }
              }
            })

            client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
          end
          return true
        end
      }
      -- Global mappings.
      -- See `:help vim.diagnostic.*` for documentation on any of the below functions
      vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, {desc="open diagnostics"})
      vim.keymap.set('n', '[d',        vim.diagnostic.goto_prev,  {desc="goto prev diagnostic"})
      vim.keymap.set('n', ']d',        vim.diagnostic.goto_next,  {desc="goto next diagnostic"})
      vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, {desc="open quickfix diagnostic "})

      -- Use LspAttach autocommand to only map the following keys
      -- after the language server attaches to the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local opts = { buffer = ev.buf }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration,    {buffer=ev.buf, desc="goto declaration"})
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition,     {buffer=ev.buf, desc="goto definition"})
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {buffer=ev.buf, desc="goto implementation"})
          vim.keymap.set('n', 'gr', vim.lsp.buf.references,     {buffer=ev.buf, desc="goto references"})
          vim.keymap.set('n', 'K',  vim.lsp.buf.hover,          {buffer=ev.buf, desc="open tooltip"})

          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename,          {buffer=ev.buf, desc="rename"})
          vim.keymap.set('n', '<leader>D',  vim.lsp.buf.type_definition, {buffer=ev.buf, desc="type definition"})
          vim.keymap.set('n', '<C-S-K>',    vim.lsp.buf.signature_help,  {buffer=ev.buf, desc="signature help"})

          vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, {buffer=ev.buf, desc="add workspace folder"})
          vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, {buffer=ev.buf, desc="remove workspace folder"})
          vim.keymap.set('n', '<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, {buffer=ev.buf, desc="list workspace folders"})

          vim.keymap.set('n', '<leader>lf', function()
            vim.lsp.buf.format { async = true }
          end, {buffer=ev.buf, desc="lsp buf format"})

          vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, {buffer=ev.buf, desc="code action"})
        end,
      })
    end
  },
}
