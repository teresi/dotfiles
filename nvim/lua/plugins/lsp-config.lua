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
          "lua_ls",
          "pyright",
          "rust_analyzer",
          "bashls",       -- BASH
          "ltex",         -- LaTeX
          "autotools_ls", -- Make
          "taplo",        -- TOML
        },
      })
    end
  },
  -- allows nvim to communicate to the LSP
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup({})
      lspconfig.pyright.setup({})
      lspconfig.rust_analyzer.setup({})
      lspconfig.autotools_ls.setup({})
    end
  }
}
