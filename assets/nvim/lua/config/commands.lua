-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- [[ Highlight on yank ]]
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- [[ append $PWD to path on startup ]]
-- fix for issue where `:find` can't find files in $PWD
local group_cdpwd = vim.api.nvim_create_augroup("group_cdpwd", { clear = true })
vim.api.nvim_create_autocmd("VimEnter", {
	group = group_cdpwd,
	pattern = "*",
	callback = function()
		vim.opt.path:append("**")
	end,
})

-- [[ remove trailing whitespace ]]
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = { "*" },
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
	callback = function()
		print("\nmason-update-all has finished\n\n")
	end,
})

-- [[ turn of diagnostics for markdown ]]
vim.api.nvim_create_autocmd({ "BufEnter" }, {
	pattern = { "*.md" },
	callback = function(args)
		vim.diagnostic.enable(not vim.diagnostic.is_enabled())
		vim.diagnostic.config({ -- https://neovim.io/doc/user/diagnostic.html
			virtual_text = false,
			signs = false,
			underline = false,
		})
	end,
})

-- [[ auto format rust using the rust analyzer ]]
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = vim.api.nvim_create_augroup("RustFormat", { clear = true }),
	pattern = { "*.rs" },
	callback = function()
		vim.lsp.buf.format({ async = false })
	end,
})

-- [[ save/load viewing settings per buffer, not window]]
vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
	pattern = { "*" },
	callback = function()
		-- Only save view for valid files
		if vim.bo.buftype == "" and vim.bo.filetype ~= "" and vim.fn.filereadable(vim.api.nvim_buf_get_name(0)) then
			vim.cmd("mkview")
		end
	end,
})
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
	pattern = { "*" },
	callback = function()
		-- Only load view for valid files
		if vim.bo.buftype == "" and vim.bo.filetype ~= "" and vim.fn.filereadable(vim.api.nvim_buf_get_name(0)) then
			vim.cmd("silent! loadview")
		end
	end,
})

-- [[ python diagnostics ]]
-- limit virtual text in python for better readability
vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	callback = function()
		vim.diagnostic.config({
			virtual_text = {
				severity = {
					min = vim.diagnostic.severity.ERROR,
				},
			},
		})
	end,
})

-- [[ spelling ]]
-- spelling causes too many false positives, so turn it off
vim.cmd("autocmd Filetype yaml,json,markdown,text setlocal nospell")
