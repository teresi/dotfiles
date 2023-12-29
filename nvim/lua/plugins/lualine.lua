-- Set lualine as statusline
-- See `:help lualine.txt`
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
        theme = 'gruvbox',
        component_separators = '|',
        section_separators = '',
      },
      sections = {
        lualine_x = {'filetype'},
      },
      inactive_sections = {
        lualine_x = {'encoding', 'fileformat'},
      },
    }
  end
}

