-- SEE the nvim port 'heraldish' from petobens/colorish
--     the colors here are from the original herald, and heraldish
--     the colors are also from older vim airline themes
return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("lualine").setup({
			options = {
				theme = "ayu_dark", -- iceberg_dark, ayu_dark, palenight, tomorrow_night, nightfly
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
