return {
    {
        "stevearc/conform.nvim",
        -- event = 'BufWritePre', -- uncomment for format on save
        opts = require "configs.conform",
    },

    -- These are some examples, uncomment them if you want to see them work!
    {
        "neovim/nvim-lspconfig",
        config = function()
            require "configs.lspconfig"
        end,
    },

    -- debugger
    {
        "mfussenegger/nvim-dap",
        config = function()
            local dap, dapui = require "dap", require "dapui"
            dap.listeners.before.attach.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                dapui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                dapui.close()
            end
        end,
    },

    -- debugger / UI
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
        config = function()
            require("dapui").setup()
        end,
    },

    -- rust
    {
        "mrcjkb/rustaceanvim",
        version = "^6", -- Recommended
        lazy = false, -- This plugin is already lazy
        ft = "rust",
        config = function()
            local mason_registry = require "mason-registry" -- required for $MASON
            -- NB mason-registry:get_install_path() has been removed, use $MASON
            local codelldb = vim.fn.expand "$MASON/packages/codelldb"
            local extension_path = codelldb .. "/extension/"
            local codelldb_path = extension_path .. "adapter/codelldb"
            local liblldb_path = extension_path .. "lldb/lib/liblldb.so"
            local cfg = require "rustaceanvim.config"

            vim.g.rustaceanvim = {
                dap = {
                    adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
                },
            }
        end,
    },

    -- syntax highlighting and etc.
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        build = ":TSUpdate",
        config = function()
            local configs = require "nvim-treesitter.configs"
            configs.setup {
                ensure_installed = {
                    "vim",
                    "vimdoc",
                    "query",
                    "lua",
                    "gitcommit",
                    "git_rebase",
                    "gitignore",
                    "gitattributes",
                    "git_config",
                    "bash",
                    "python",
                    "rust",
                    "c",
                    "cpp",
                    "make",
                    "cmake",
                    "meson",
                    "ninja",
                    "cuda",
                    "latex",
                    "bibtex",
                    "ssh_config",
                    "dockerfile",
                    "proto",
                    "regex",
                    "markdown",
                    "json",
                    "toml",
                    "yaml",
                },
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = true },
            }
        end,
    },

}
