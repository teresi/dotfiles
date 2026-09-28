return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		-- NOTE: not adding shellcheck for bash or sh, as bashls is running it
		-- and adding it here would result in duplicate diagnostics
		lint.linters_by_ft = {
			lua = { "luacheck" },
			make = { "checkmake" },
		}

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
