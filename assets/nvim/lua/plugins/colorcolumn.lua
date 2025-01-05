return {
  "ecthelionvi/NeoColumn.nvim",
  opts = {
  },
  config = function()
    require("NeoColumn").setup({
      NeoColumn = "90",
      always_on = false,
      bg_color = "#FFEE68",
    })
  end
}
