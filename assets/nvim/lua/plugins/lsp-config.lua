return {
	-- Main LSP Configuration
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} },
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		{ "j-hui/fidget.nvim", opts = {} },
		"saghen/blink.cmp",
	},
	config = function()
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
			callback = function(event)
				-- NOTE: Remember that Lua is a real programming language, and as such it is possible
				-- to define small helper and utility functions so you don't have to repeat yourself.
				--
				-- In this case, we create a function that lets us more easily define mappings specific
				-- for LSP related items. It sets the mode, buffer and description for us each time.
				local map = function(keys, func, desc, mode)
					mode = mode or "n"
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				-- Rename the variable under your cursor.
				--  Most Language Servers support renaming across files, etc.
				map("grn", vim.lsp.buf.rename, "[R]e[n]ame")

				-- Show docs on hover
				map("gh", vim.lsp.buf.hover, "[G]to [H]over")
				map("gk", vim.lsp.buf.hover, "[G]to [H]over")

				-- Execute a code action, usually your cursor needs to be on top of an error
				-- or a suggestion from your LSP for this to activate.
				map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })

				map("<leader>e", vim.diagnostic.open_float, "open diagnostics")

				-- Find references for the word under your cursor.
				map("grr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

				-- Jump to the implementation of the word under your cursor.
				--  Useful when your language has ways of declaring types without an actual implementation.
				map("gri", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

				-- Jump to the definition of the word under your cursor.
				--  This is where a variable was first declared, or where a function is defined, etc.
				--  To jump back, press <C-t>.
				map("grd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

				-- WARN: This is not Goto Definition, this is Goto Declaration.
				--  For example, in C this would take you to the header.
				map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

				-- Fuzzy find all the symbols in your current document.
				--  Symbols are things like variables, functions, types, etc.
				map("gO", require("telescope.builtin").lsp_document_symbols, "Open Document Symbols")

				-- Fuzzy find all the symbols in your current workspace.
				--  Similar to document symbols, except searches over your entire project.
				map("gW", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Open Workspace Symbols")

				-- Jump to the type of the word under your cursor.
				--  Useful when you're not sure what type a variable is and you want to see
				--  the definition of its *type*, not where it was *defined*.
				map("grt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")

				-- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
				---@param client vim.lsp.Client
				---@param method vim.lsp.protocol.Method
				---@param bufnr? integer some lsp support methods only in specific files
				---@return boolean
				local function client_supports_method(client, method, bufnr)
					if vim.fn.has("nvim-0.11") == 1 then
						return client:supports_method(method, bufnr)
					else
						return client.supports_method(method, { bufnr = bufnr })
					end
				end

				-- The following two autocommands are used to highlight references of the
				-- word under your cursor when your cursor rests there for a little while.
				--    See `:help CursorHold` for information about when this is executed
				--
				-- When you move your cursor, the highlights will be cleared (the second autocommand).
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if
					client
					and client_supports_method(
						client,
						vim.lsp.protocol.Methods.textDocument_documentHighlight,
						event.buf
					)
				then
					local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})

					vim.api.nvim_create_autocmd("LspDetach", {
						group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
						callback = function(event2)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
						end,
					})
				end

				-- The following code creates a keymap to toggle inlay hints in your
				-- code, if the language server you are using supports them
				--
				-- This may be unwanted, since they displace some of your code
				if
					client
					and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
				then
					map("<leader>th", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
					end, "[T]oggle Inlay [H]ints")
				end
			end,
		})

		-- Diagnostic Config
		-- See :help vim.diagnostic.Opts
		vim.diagnostic.config({
			severity_sort = true,
			float = { border = "rounded", source = "if_many" },
			underline = { severity = vim.diagnostic.severity.ERROR },
			signs = vim.g.have_nerd_font and {
				text = {
					[vim.diagnostic.severity.ERROR] = "󰅚 ",
					[vim.diagnostic.severity.WARN] = "󰀪 ",
					[vim.diagnostic.severity.INFO] = "󰋽 ",
					[vim.diagnostic.severity.HINT] = "󰌶 ",
				},
			} or {},
			virtual_text = {
				source = "if_many",
				spacing = 2,
				format = function(diagnostic)
					local diagnostic_message = {
						[vim.diagnostic.severity.ERROR] = diagnostic.message,
						[vim.diagnostic.severity.WARN] = diagnostic.message,
						[vim.diagnostic.severity.INFO] = diagnostic.message,
						[vim.diagnostic.severity.HINT] = diagnostic.message,
					}
					return diagnostic_message[diagnostic.severity]
				end,
			},
		})

		-- LSP servers and clients are able to communicate to each other what features they support.
		--  By default, Neovim doesn't support everything that is in the LSP specification.
		--  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
		--  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
		local capabilities = require("blink.cmp").get_lsp_capabilities()

		-- Enable the LSP servers below.
		-- External server installation is managed separately:
		--   - basedpyright: uv
		--   - quickmark: cargo
		--   - gopls and other tools: Mason where applicable
		local servers = {
			lua_ls = {
				-- cmd = { ... },
				-- filetypes = { ... },
				-- capabilities = {},
				settings = {
					Lua = {
						completion = {
							callSnippet = "Replace",
						},
						-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
						-- diagnostics = { disable = { 'missing-fields' } },
					},
				},
			},

			basedpyright = {
				settings = {
					-- SEE: https://docs.basedpyright.com/v1.20.0/configuration/language-server-settings/
					basedpyright = {
						disableOrganizeImports = true,
						analysis = {
							diagnosticMode = "openFilesOnly", -- workspace / openFilesOnly
							typeCheckingMode = "recommended", -- off / basic / standard / strict / recommended / all
							useLibraryCodeForTypes = true,
							inlayHints = {
								callArgumentNames = true, --- show inlays on function args
								variableTypes = true, -- show inlays on assignments
								functionReturnTypes = true, -- show inlays on return types
								genericTypes = true, -- show inlays on inferred generic types
							},
							-- SEE: https://docs.basedpyright.com/v1.20.0/configuration/config-files/#type-check-diagnostics-settings
							diagnosticSeverityOverrides = { -- error, warning, information, true, false, none
								autoSearchPaths = true,
								enableTypeIgnoreComments = true,
								reportGeneralTypeIssues = true,
								reportArgumentType = true,
								reportUnknownMemberType = true,
								reportAssignmentType = true,
								reportUnusedImport = "information",
								reportAny = "warning",
								reportMissingTypeArgument = true,
								reportMissingParameterType = true,
								reportMissingTypeStubs = true,
								reportUnknownArgumentType = true,
								reportUnknownParameterType = true,
								reportUnknownVariableType = "warning",
								reportUnusedCallResult = "information",
							},
						},
					},
				},
			},

			gopls = {
				settings = {
					gopls = {
						["ui.inlayhint.hints"] = {
							assignVariableTypes = true,
							compositeLiteralFields = true,
							compositeLiteralTypes = true,
							constantValues = true,
							functionTypeParameters = true,
							parameterNames = true,
							rangeVariableTypes = true,
						},
						analyses = {
							unusedparams = true,
						},
						staticcheck = true,
					},
				},
			},

			quickmark = {
				cmd = { vim.fn.expand("$HOME/.cargo/bin/quickmark-server") },
				filetypes = { "markdown" },
				root_markers = { "quickmark.toml", ".git", "package.json" },
				settings = {},
				single_file_support = true,
			},

			bashls = {
				cmd = { "bashls" },
				filetypes = { "sh", "bash" },
				root_markers = { ".git" },
			},
		}

		-- NOTE: installing basedpyright here isn't necessary since we install in the top makefile
		-- but left here as an example
		local server_path = vim.fn.expand("$HOME/.local/bin/basedpyright-langserver")
		if vim.fn.executable(server_path) == 0 and vim.fn.executable("uv") == 1 then
			vim.fn.jobstart({ "uv", "tool", "install", "basedpyright" }, {
				on_exit = function(_, code)
					if code == 0 then
						vim.notify("basedpyright installed")
					else
						vim.notify("failed to install basedpyright", vim.log.levels.ERROR)
					end
				end,
			})
		end

		-- enable the LSP servers
		for name, config in pairs(servers) do
			config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
			vim.lsp.config(name, config)
			vim.lsp.enable(name)
		end

		-- setup mason managed CLI tools
		-- NOTE: do _not_ install rust_analyzer, it is installed manually (for more control over the version)
		-- NOTE: do _not_ install basedpyright, it is installed by uv (to remove dependency on python3.XX-venv)
		-- NOTE: do _not_ install bash-language-server, bashls is manually installed instead (doesn't require npm)
		require("mason-tool-installer").setup({
			ensure_installed = {
				"stylua",
				"codelldb",
				"shfmt", -- bash formatting
				"shellcheck", -- bash diagnostics
				"yq",
				"jq",
				"tex-fmt",
				"gopls",
			},
		})
	end,
}
