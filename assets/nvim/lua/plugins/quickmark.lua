return {
	"neovim/nvim-lspconfig",
	-- Lazy.nvim merges this block seamlessly with your main lsp-config.lua!
	config = function()
		local lspconfig = require("lspconfig")
		local configs = require("lspconfig.configs")

		-- 1. Register quickmark inside lspconfig's engine index if missing
		if not configs.quickmark then
			configs.quickmark = {
				default_config = {
					-- Dynamically resolves to your exact $HOME/.cargo/bin location
					cmd = { vim.fn.expand("$HOME/.cargo/bin/quickmark-server") },
					filetypes = { "markdown" },
					root_dir = lspconfig.util.root_pattern("quickmark.toml", ".git", "package.json"),
					settings = {},
					single_file_support = true,
				},
			}
		end

		-- 2. Launch the server instance
		lspconfig.quickmark.setup({})

		-- 3. Bootstrap: Install the backend binary automatically if missing
		local server_path = vim.fn.expand("$HOME/.cargo/bin/quickmark-server")
		if vim.fn.executable(server_path) == 0 and vim.fn.executable("cargo") == 1 then
			vim.fn.jobstart({ "cargo", "install", "quickmark-server" }, {
				on_exit = function(_, code)
					if code == 0 then
						-- Safely kickstart the server without needing an editor restart
						pcall(lspconfig.quickmark.setup, {})
					end
				end,
			})
		end
	end,
}
