return {
	"mrcjkb/rustaceanvim",
	version = "^8",
	lazy = false, -- This plugin is already lazy
	init = function()
		vim.g.rustaceanvim = {
			server = {
				default_settings = {
					-- rust-analyzer language server configuration
					-- SEE: https://rust-analyzer.github.io/book/configuration
					["rust-analyzer"] = {
						check = { command = "clippy", allTargets = true },
						checkOnSave = true,
						cargo = { targetDir = true },
						diagnostics = {
							enable = true,
							styleLints = true,
							disabled = {},
							experimental = { enable = true },
						},
						files = {
							exclude = {
								".direnv",
								".git",
								".jj",
								".github",
								".gitlab",
								"bin",
								"node_modules",
								"target",
								"venv",
								".venv",
							},
						},
						watcher = "client",
					},
				},
			},
		}
	end,
}
