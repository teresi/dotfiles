require "nvchad.autocmds"


-- [[ auto format rust using the rust analyzer ]]
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    group = vim.api.nvim_create_augroup("RustFormat", { clear = true }),
    pattern = {"*.rs"},
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})


-- [[ Highlight on yank ]]
-- see `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

