return {
	"zaldih/themery.nvim",
	lazy = false,
	config = function()
		require("themery").setup({
			themes = { -- Your list of installed colorschemes.
				"adwaita",
				"elflord",
				"citruszest",
				"habamax",
				"industry",
				"heraldish",
				"koehler",
				"lunaperche",
				"moonfly",
				"slate",
				"sorbet",
				"tokyonight-night",
				"torte",
				"unokai",
				"wildcharm",
				"zaibatsu",
			},
			livePreview = true, -- Apply theme while picking. Default to true.
		})
	end,
}
