-- Highlight todo, notes, etc in comments
-- TEST:
-- INFO:
-- TODO:
-- NOTE:
-- ERROR:
-- WARN:
-- HACK:
-- FUTURE:
--    custom_onedark.normal.c.bg = '#1C1B1A'
--    custom_onedark.normal.a.bg = '#87D787'
--    custom_onedark.insert.a.bg = '#00AFFF'
--    custom_onedark.visual.a.bg = '#D75FD7'
return {
	"folke/todo-comments.nvim",
	event = "VimEnter",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		signs = false,
		keywords = {
			FIX = {
				icon = " ", -- icon used for the sign, and in search results
				color = "error", -- can be a hex color, or a named color (see below)
				alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
				-- signs = false, -- configure signs for some keywords individually
			},
			TODO = { icon = " ", color = "info" },
			FUTURE = { icon = " ", color = "#1C1B1A" },
			HACK = { icon = " ", color = "warning" },
			WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
			ERROR = { icon = " ", color = "error" },
			PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
			INFO = { icon = " ", color = "#00AFFF" },
			NOTE = { icon = " ", color = "#10B981" },
			TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
		},
		colors = {
			error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
			warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
			info = { "DiagnosticInfo", "#2563EB" },
			hint = { "DiagnosticHint", "#10B981" },
			default = { "Identifier", "#7C3AED" },
			test = { "Identifier", "#FF00FF" },
		},
	},
}
