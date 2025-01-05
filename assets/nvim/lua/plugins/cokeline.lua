
-- #1C1B1A    gray background
-- #AFAFAF    white text
-- #87D787    green (selected)
-- #00AFFF    cyan (selected AND modified)
-- #D75FD7    magenta

return {
  "willothy/nvim-cokeline",
  dependencies = {
    "nvim-lua/plenary.nvim",        -- Required for v0.4.0+
    "stevearc/resession.nvim"       -- Optional, for persistent history
  },
  config = function()
    require('cokeline').setup{
    show_if_buffers_are_at_least = 1,


    -- The default highlight group values.
    -- The `fg`, `bg`, and `sp` keys are either colors in hexadecimal format or
    -- functions taking a `buffer` parameter and returning a color in
    -- hexadecimal format. Style attributes work the same way, but functions
    -- should return boolean values.
    default_hl = {
      -- default: `ColorColumn`'s background color for focused buffers,
      -- `Normal`'s foreground color for unfocused ones.
      ---@type nil | string | fun(buffer: Buffer): string
      fg = function(buffer)
        local hlgroups = require("cokeline.hlgroups")
        return buffer.is_focused and '#262626'
          or not buffer.is_modified and '#87D787'
          or '#AFAFAF'
      end,

      -- default: `Normal`'s foreground color for focused buffers,
      --
      -- `ColorColumn`'s background color for unfocused ones.
      -- default: `Normal`'s foreground color.
      ---@type nil | string | function(buffer: Buffer): string,
      bg = function(buffer)
        local hlgroups = require("cokeline.hlgroups")
        return buffer.is_focused and not buffer.is_modified and '#87D787'
          or buffer.is_focused and '#00AFFF'
          or '#1C1B1A'
      end,

      -- default: unset.
      ---@type nil | string | function(buffer): string,
      sp = nil,

      ---@type nil | boolean | fun(buf: Buffer):boolean
      bold = nil,
      ---@type nil | boolean | fun(buf: Buffer):boolean
      italic = nil,
      ---@type nil | boolean | fun(buf: Buffer):boolean
      underline = nil,
      ---@type nil | boolean | fun(buf: Buffer):boolean
      undercurl = nil,
      ---@type nil | boolean | fun(buf: Buffer):boolean
      strikethrough = nil,
    },

    components = {
        {
          text = function(buffer) return ' ' .. buffer.unique_prefix end,
          fg = function(buffer)
            local hlgroups = require("cokeline.hlgroups")
            hlgroups.get_hl_attr('Comment', 'fg')
          end,
          italic = true
        },
        {
          text = function(buffer) return buffer.filename end,
          underline = function(buffer)
            return buffer.is_hovered and not buffer.is_focused
          end
        },
        {
          text = function(buffer) return buffer.is_modified and '+ ' or ' ' end,
        },
    },
    }
  end
}
