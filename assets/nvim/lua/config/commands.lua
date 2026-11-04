-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- [[ Highlight on yank ]]
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("HighlightYank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- [[ append $PWD to path on startup ]]
-- fix for issue where `:find` can't find files in $PWD
local group_cdpwd = vim.api.nvim_create_augroup("ChangeDirectoryPath", { clear = true })
vim.api.nvim_create_autocmd("VimEnter", {
	pattern = "*",
	group = group_cdpwd,
	callback = function()
		vim.opt.path:append("**")
	end,
})

-- [[ remove trailing whitespace ]]
local whitespace_group = vim.api.nvim_create_augroup("RemoveTrailingWhitespace", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	group = whitespace_group,
	callback = function()
		local save_cursor = vim.fn.getpos(".")
		pcall(function()
			vim.cmd([[%s/\s\+$//e]])
		end)
		vim.fn.setpos(".", save_cursor)
	end,
})

-- [[ update Mason from command line ]]
-- nvim --headless -c 'autocmd User MasonUpdateAllComplete quitall' -c 'MasonUpdateAll'
vim.api.nvim_create_autocmd("User", {
	pattern = "MasonUpdateAllComplete",
	group = vim.api.nvim_create_augroup("MasonUpdate", { clear = true }),
	callback = function()
		print("\nmason-update-all has finished\n\n")
	end,
})

-- [[ turn off diagnostics for markdown ]]
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	group = vim.api.nvim_create_augroup("MarkownDiagnostics", { clear = true }),
	callback = function(args)
		vim.diagnostic.enable(false, { bufnr = args.buf })
	end,
})

-- [[ auto format rust using the rust analyzer ]]
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = { "*.rs" },
	group = vim.api.nvim_create_augroup("RustFormat", { clear = true }),
	callback = function()
		vim.lsp.buf.format({ async = false })
	end,
})

-- [[ save/load viewing settings per file]]
local view_group = vim.api.nvim_create_augroup("RestoreView", { clear = true })
vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
	pattern = { "*" },
	group = view_group,
	callback = function()
		-- Only save view for valid files
		if
			vim.bo.buftype == ""
			and vim.bo.filetype ~= ""
			and vim.fn.filereadable(vim.api.nvim_buf_get_name(0))
		then
			vim.cmd("mkview")
		end
	end,
})
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
	pattern = { "*" },
	group = view_group,
	callback = function()
		-- Only load view for valid files
		if
			vim.bo.buftype == ""
			and vim.bo.filetype ~= ""
			and vim.fn.filereadable(vim.api.nvim_buf_get_name(0))
		then
			vim.cmd("silent! loadview")
		end
	end,
})

-- [[ register filetypes by extension ]]
vim.filetype.add({
	extension = {
		pyx = "python",
	},
})

-- [[ spelling ]]
-- spelling causes too many false positives, so turn it off
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "yaml", "json", "markdown", "text" },
	group = vim.api.nvim_create_augroup("NoSpelling", { clear = true }),
	command = "setlocal nospell",
})

-- [[ syntax highlighting ]]
-- Force tree sitter to handle syntax highlighting by disabling lsp semantic tokens
-- This has been faster, and provided better colors for some languages
-- NB: this however does apply to all lsp clients
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("LspAttach", { clear = true }),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client then
			client.server_capabilities.semanticTokensProvider = nil
		end
	end,
})

-- [[ tools for working with LSPs ]]
--
-- alias for the old syntax
-- the new command is `:lsp info`
-- NOTE:  commands are
-- :lsp info
-- :lsp restart
-- :lsp restart clangd  # or other server
--
vim.api.nvim_create_user_command("LspInfo", function()
	vim.cmd("checkhealth vim.lsp")
end, {
	desc = "Show LSP health information",
	force = true,
})
