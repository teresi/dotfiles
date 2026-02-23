-- NOTE: Do not set vim.g.rustaceanvim in after/ftplugin/rust.lua, as the file is sourced after the plugin is initialized.
local bufnr = vim.api.nvim_get_current_buf()
vim.keymap.set("n", "<leader>a", function()
	vim.cmd.RustLsp("codeAction") -- supports rust-analyzer's grouping
	-- or vim.lsp.buf.codeAction() if you don't want grouping.
end, { silent = true, buffer = bufnr })
vim.keymap.set(
	"n",
	"K", -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
	function()
		vim.cmd.RustLsp({ "hover", "actions" })
	end,
	{ silent = true, buffer = bufnr }
)

-- SEE: (:help lsp-semantic-highlight)
-- SEE: https://www.reddit.com/r/neovim/comments/12rc7h4/issue_with_syntax_highlighting_in_rust_with/
--
-- NOTE: there is more than one highlighting system,
-- if tree-sitter hasn't started, you could disable semantic highlights to change the colors
--
-- Hide semantic highlights for functions
--vim.api.nvim_set_hl(0, "@lsp.type.function", {})
--
-- Hide all semantic highlights
--for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
--	vim.api.nvim_set_hl(0, group, {})
--end
