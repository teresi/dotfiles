return {
  {'tpope/vim-fugitive'},
  {'tpope/vim-rhubarb'},
  -- Close using :Bclose or <leader>bd
  {'rbgrouleff/bclose.vim'},
  -- Detect tabstop and shiftwidth automatically
  {'tpope/vim-sleuth'},
  {
      'nvim-tree/nvim-tree.lua',
      lazy = true,
      dependencies = {
          'nvim-tree/nvim-web-devicons',
      },
  },

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

--  { -- Autocompletion
--    'hrsh7th/nvim-cmp',
--    dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
--  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', opts = {} },

  {
    'petobens/colorish',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'heraldish'
      vim.cmd.highlight 'cursorline guibg=#000000'
      vim.cmd.highlight 'LineNR guibg=#000000'
      vim.cmd.highlight 'CursorLineNr guifg=yellow'
      vim.cmd.hi        'Comment ctermfg=243 guifg=#626262'
    end,
  },
  {
    "norcalli/nvim-colorizer.lua",
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  { 'nvim-telescope/telescope.nvim', version = '*', dependencies = { 'nvim-lua/plenary.nvim' } },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available. Make sure you have the system
  -- requirements installed.
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  },

  {
    'akinsho/bufferline.nvim',
    version = "v3.*",
  },

  {
    'm-demare/hlargs.nvim',
  },

  {
    'theHamsta/nvim-semantic-tokens',
  },

  {
    'sheerun/vim-polyglot'
  },

--  {'romgrk/barbar.nvim',
--    dependencies = 'nvim-tree/nvim-web-devicons',
--    opts = {
--      animation = false,
--      highlight_alternate = false,
--      icons = {
--        buffer_index = true,
--        filetype = {
--          enabled = false,
--          custom_colors = true,
--        },
--      },
--    },
--    version = '^1.0.0', -- optional: only update when a new 1.x version is released
--  },
--  {
--  'nvim-telescope/telescope.nvim', tag = '0.1.1',
--    dependencies = { 'nvim-lua/plenary.nvim' }
--  },

  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

}

