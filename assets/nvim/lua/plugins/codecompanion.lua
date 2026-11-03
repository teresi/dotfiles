return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		local active_adapter

		if vim.env.STARK_API_KEY and vim.env.STARK_API_KEY ~= "" then
			active_adapter = "stark"
		elseif vim.env.GEMINI_API_KEY and vim.env.GEMINI_API_KEY ~= "" then
			active_adapter = "gemini"
		else
			vim.notify(
				"CodeCompanion: Neither STARK_API_KEY nor GEMINI_API_KEY is set!",
				vim.log.levels.WARN
			)
			return
		end

		require("codecompanion").setup({
			display = {
				chat = {
					show_header_separator = true, -- Adds a horizontal line beneath role headers
					separator = "─", -- The character used for the separator
					show_settings = true,
				},
			},
			interactions = {
				chat = {
					adapter = active_adapter,
					roles = {
						llm = "Abominus Intelligence",
						user = "Me",
					},
				},
				inline = {
					adapter = active_adapter,
				},
			},

			adapters = {
				http = {
					stark = function()
						return require("codecompanion.adapters").extend("openai_compatible", {
							name = "stark",
							env = {
								url = "https://api.genai.mil",
								chat_url = "/v1/chat/completions",
								api_key = "STARK_API_KEY",
							},
							schema = {
								model = {
									default = "gemini-4-argon-withtools",
								},
							},
						})
					end,
					gemini = function()
						return require("codecompanion.adapters").extend("gemini", {
							schema = {
								model = {
									default = "gemini-3.8-flash",
									choices = {
										"gemini-3.8-flash",
									},
								},
							},
						})
					end,
				},
			},
			opts = {
				log_level = "DEBUG",
			},
		})

		vim.keymap.set(
			{ "n", "v" },
			"<leader>a",
			"<cmd>CodeCompanionChat Toggle<cr>",
			{ desc = "AI Chat Toggle" }
		)

		vim.keymap.set(
			{ "n", "v" },
			"<leader>ai",
			"<cmd>CodeCompanion<cr>",
			{ desc = "AI Inline Prompt" }
		)

		vim.keymap.set(
			"v",
			"ga",
			"<cmd>CodeCompanionChat Add<cr>",
			{ desc = "Add Selection to AI Chat" }
		)
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "codecompanion",
			callback = function(args)
				vim.bo[args.buf].buftype = "acwrite"
				if vim.api.nvim_buf_get_name(args.buf) == "" then
					vim.api.nvim_buf_set_name(args.buf, "CodeCompanion_" .. args.buf)
				end

				vim.api.nvim_create_autocmd("BufWriteCmd", {
					buffer = args.buf,
					callback = function()
						vim.bo[args.buf].modified = false
						local chat = require("codecompanion").buf_get_chat(args.buf)
						if chat then
							chat:submit()
						end
					end,
				})
			end,
		})
	end,
}
