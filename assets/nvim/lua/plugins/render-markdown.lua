return {
	"MeanderingProgrammer/render-markdown.nvim",
	--dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" }, -- if you use the mini.nvim suite
	--dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" }, -- if you use standalone mini plugins
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons

	keys = {
		{
			"<leader>mp",
			function()
				local buf = vim.api.nvim_get_current_buf()
				require("render-markdown").preview()
				-- Re-disable rendering in source buffer after the preview closes.
				-- plugin unconditionally re-enables it when closing its preview.
				-- vim.schedule() ensures this runs after the preview callback.
				vim.schedule(function()
					if vim.api.nvim_buf_is_valid(buf) then
						vim.api.nvim_buf_call(buf, function()
							require("render-markdown").buf_disable()
						end)
					end
				end)
			end,
			desc = "[M]arkdown [P]review",
			ft = "markdown",
		},
		{
			"<leader>mt",
			"<cmd>RenderMarkdown buf_toggle<cr>",
			desc = "[M]arkdown [T]oggle",
			ft = "markdown",
		},
	},

	---@module 'render-markdown'
	---@type render.md.UserConfig
	opts = {
		enabled = false, -- startup w/o rendering
		overrides = {
			preview = {
				enabled = true, -- enable when in preview
			},
		},
	},
}
