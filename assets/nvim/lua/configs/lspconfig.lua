require("configs.lspconfig_defaults").defaults()  -- from nvchad

local servers = { "html", "cssls" }
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers 
