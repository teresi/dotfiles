return { -- Highlight, edit, and navigate code
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		local ts = require("nvim-treesitter")
		local languages = {
			"bash",
			"c",
			"diff",
			"html",
			"lua",
			"luadoc",
			"markdown",
			"markdown_inline",
			"query",
			"rust",
			"toml",
			"vim",
			"vimdoc",
			"yaml",
		}
		-- NB: make sure to install tree-sitter-cli (cargo install tree-sitter-cli)
		ts.setup({})
		ts.install(languages)

		-- SEE: https://mhpark.me/posts/update-treesitter-main/
		-- Not every tree-sitter parser is the same as the file type detected
		-- So the patterns need to be registered more cleverly
		local patterns = {}
		for _, parser in ipairs(languages) do
			local parser_patterns = vim.treesitter.language.get_filetypes(parser)
			for _, pp in pairs(parser_patterns) do
				table.insert(patterns, pp)
			end
		end

		-- Treesitter features for installed languages must be enabled manually
		vim.api.nvim_create_autocmd("FileType", {
			pattern = languages,
			callback = function()
				-- Enable native Neovim treesitter highlighting
				vim.treesitter.start()

				-- Configure code folding
				vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
				vim.wo.foldmethod = "expr"
				vim.wo.foldlevel = 99

				-- Enable treesitter-based indentation
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end,
}
