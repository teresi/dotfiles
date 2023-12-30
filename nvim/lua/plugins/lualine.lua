-- SEE the nvim port 'heraldish' from petobens/colorish
--     the colors here are from the original herald, and heraldish
--     the colors are also from older vim airline themes
return {
  'nvim-lualine/lualine.nvim',
  config = function()
    local custom_onedark = require'lualine.themes.onedark'
    custom_onedark.normal.c.bg = '#1C1B1A'
    custom_onedark.normal.a.bg = '#87D787'
    custom_onedark.insert.a.bg = '#00AFFF'
    custom_onedark.visual.a.bg = '#D75FD7'
    require('lualine').setup {
      options = {
        theme = custom_onedark,
        icons_enabled = false,
        padding = 1,
        component_separators = '|',
        section_separators = '',
        disabled_filetypes = {
          'packer',
          'neo-tree',
        },
      },
      sections = {
        lualine_a = {'mode'},
        lualine_b = {},
        lualine_c = {
          {
            'filename',
            color = { fg = '#87D787' },
          }
        },
        lualine_x = {'filetype'},
        lualine_y = {'diff', 'diagnostics'},
        lualine_z = {'progress', 'location'},
      },
      inactive_sections = {
        lualine_x = {'encoding', 'fileformat'},
      },
    }
  end
}

