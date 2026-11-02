return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"hrsh7th/nvim-cmp",
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		-- personal token
		local active_adapter = "gemini"
		--local active_adapter = "openrouter"
		-- If the STARK_API_KEY environment variable exists and isn't empty, use it
		if os.getenv("STARK_API_KEY") ~= nil and os.getenv("STARK_API_KEY") ~= "" then
			active_adapter = "stark"
		else
			local gemini_key = os.getenv("GEMINI_API_KEY")
			if gemini_key == nil or gemini_key == "" then
				vim.notify(
					"CodeCompanion: GEMINI_API_KEY environment variable is not set!",
					vim.log.levels.WARN
				)
			end
		end

		require("codecompanion").setup({
			display = {
				chat = {
					show_header_separator = true, -- Adds a horizontal line beneath role headers
					separator = "─", -- The character used for the separator
				},
			},
			strategies = {
				chat = {
					adapter = active_adapter,
					roles = {
						llm = "Abominus Intelligence",
						user = "Me",
					},
				},
				inline = {
					adapter = {
						name = active_adapter,
					},
				},
			},

			adapters = {
				stark = function()
					return require("codecompanion.adapters").extend("openai_compatible", {
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
					return require("codecompanion.adapters").extend("openai_compatible", {
						env = {
							url = "https://googleapis.com",
							chat_url = "/chat/completions",
							api_key = "GEMINI_API_KEY",
						},
						schema = {
							model = {
								default = "gemini-3.6-flash",
							},
						},
					})
				end,
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
