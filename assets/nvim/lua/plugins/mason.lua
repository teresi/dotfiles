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
                    "bashls",
                    "docker_compose_language_service",
                    "dockerls",
                    "jsonls",
                    "ltex",
                    "texlab",
                    "lua_ls",
                    "pyright",
                    "rust_analyzer",
                    "taplo", -- TOML
                    "codelldb",
                    "yamlls",
                },
            })
        end
    }
}
