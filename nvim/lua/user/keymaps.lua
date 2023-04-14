function Map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

Map("n", "<C-h>", "<C-w>h")
Map("n", "<C-j>", "<C-w>j")
Map("n", "<C-k>", "<C-w>k")
Map("n", "<C-l>", "<C-w>l")

Map("n", "<C-Up>", ":resize -2<CR>")
Map("n", "<C-Down>", ":resize +2<CR>")
Map("n", "<C-Left>", ":vertical resize -2<CR>")
Map("n", "<C-Right>", ":vertical resize +2<CR>")

-- move a block of text
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- indent
Map("v", "<", "<gv")
Map("v", ">", ">gv")

-- tab to cycle buffer
Map("n", "<TAB>", ":bn<CR>")
Map("n", "<S-TAB>", ":bp<CR>")
Map("n", "<leader>bd", ":bd<CR>") -- from Doom Emacs

-- telescope
--Mac("n", "<leader>ff", "<cmd> Telescope find_files <CR>")
--Map("n", "<leader>fa", "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>")
--Map("n", "<leader>fe", "<cmd> Telescope file_browser <CR>")
--Map("n", "<leader>fw", "<cmd> Telescope live_grep <CR>")
--Map("n", "<leader>fb", "<cmd> Telescope buffers <CR>")
--Map("n", "<leader>fh", "<cmd> Telescope help_tags <CR>")
--Map("n", "<leader>fo", "<cmd> Telescope oldfiles <CR>")
--Map("n", "<leader>fc", "<cmd> Telescope colorschemes <CR>")

-- lsp
Map("n", "<leader>gd", ":lua vim.lsp.buf.definition()<CR>")
Map("n", "<leader>gi", ":lua vim.lsp.buf.implementation()<CR>")
Map("n", "K", ":lua vim.lsp.buf.hover()<CR>")
Map("n", "<leader>rn", ":lua vim.lsp.buf.rename()<CR>")
Map("n", "<leader>gr", ":lua vim.lsp.buf.references()<CR>")


Map('n', "<F2>", "<cmd>NvimTreeToggle<cr>")
