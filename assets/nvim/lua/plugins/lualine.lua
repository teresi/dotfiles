-- SEE the nvim port 'heraldish' from petobens/colorish
--     the colors here are from the original herald, and heraldish
--     the colors are also from older vim airline themes

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local deus = require("lualine.themes.ayu_dark")
		deus.normal.a.bg = "#87D787"
		deus.normal.a.fg = "#000000"

		deus.normal.c.bg = "#000000"
		deus.normal.c.fg = "#AFAFAF"

		deus.insert.a.bg = "#00AFFF"
		deus.insert.a.fg = "#000000"

		deus.visual.a.bg = "#D75FD7"
		deus.visual.a.fg = "#000000"

		deus.replace.a.bg = "#FF5F8F"
		deus.replace.a.fg = "#000000"

		require("lualine").setup({
			options = {
				theme = deus, -- iceberg_dark, ayu_dark, palenight, tomorrow_night, nightfly
				icons_enabled = false,
				padding = 1,
				component_separators = "|",
				section_separators = "",
				disabled_filetypes = {
					"packer",
					"neo-tree",
				},
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = {},
				lualine_c = {
					{
						"filename",
					},
				},
				lualine_x = { "filetype" },
				lualine_y = { "diff", "diagnostics" },
				lualine_z = { "progress", "location" },
			},
			inactive_sections = {
				lualine_x = { "encoding", "fileformat" },
			},
		})
	end,
}
