return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ":TSUpdate",
    config = function ()
        local configs = require("nvim-treesitter.configs")
        configs.setup({
            ensure_installed = {
                'vim', 'vimdoc', 'query', 'lua',
                'gitcommit', 'git_rebase',
                'gitignore', 'gitattributes',
                'git_config',
                'bash',
                'python',
                'rust',
                'c', 'cpp',
                'make', 'cmake', 'meson', 'ninja',
                'cuda',
                'latex', 'bibtex',
                'ssh_config',
                'dockerfile',
                'proto', 'regex',
                'markdown', 'json', 'toml', 'yaml',
            },
            sync_install = false,
            highlight = { enable = true },
            indent = { enable = true },
        })
    end
}
