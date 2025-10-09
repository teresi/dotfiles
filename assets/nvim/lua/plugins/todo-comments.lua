-- Highlight todo, notes, etc in comments
-- TEST: test
-- MAGIC: magic number
-- INFO: info
-- TODO: todo
-- NOTE: note
-- NB: nota bene
-- ERROR: error
-- BUG: error
-- WARN: warning
-- HACK: hack
-- FUTURE: future
-- SEE: see link
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
			MAGIC = { icon = "★ ", color = "#720092" },
			FUTURE = { icon = " ", color = "#918C88" },
			SEE = { icon = " ", color = "#918C88" },
			HACK = { icon = " ", color = "warning" },
			WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
			ERROR = { icon = " ", color = "error" },
			BUG = { icon = " ", color = "error" },
			PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
			INFO = { icon = " ", color = "#00AFFF" },
			NOTE = { icon = " ", color = "#10B981", alt = { "NB" } },
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
