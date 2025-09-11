return { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {},
    config = function()
        require('ibl').setup {
            indent = {
                char = { '|', '¦', '┆', '┊' },
            },
            scope = {
                enabled = true,
                show_start = false,
                show_end = false,
            },
        }
        local hooks = require 'ibl.hooks'
        hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
    end,
}
