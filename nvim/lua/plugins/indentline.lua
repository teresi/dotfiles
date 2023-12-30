
return { -- Add indentation guides even on blank lines
  'lukas-reineke/indent-blankline.nvim',
  main = "ibl",
  opts = {},
  config = function()
    require("ibl").setup {
      indent = {
        char = {'¦', '┆', '┊'},
      },
      scope = {
        enabled = true,
        show_start = false,
        show_end = false,
      },
    }
  end
}

