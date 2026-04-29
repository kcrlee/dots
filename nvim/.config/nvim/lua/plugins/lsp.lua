return {
	config = function()
		require("mason").setup({
			registries = { "github:crashdummyy/mason-registry", "github:mason-org/mason-registry" },
		})
		require("mason-lspconfig").setup()

		vim.lsp.config("*", {
			capabilities = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), {
				textDocument = {
					completion = {
						completionItem = {
							snippetSupport = true,
							resolveSupport = {
								properties = { "documentation", "detail", "additionalTextEdits" },
							},
						},
					},
				},
			}),
		})

		local kind_icons = {
			Text = "󰉿",
			Method = "󰊕",
			Function = "󰊕",
			Constructor = "",
			Field = "󰜢",
			Variable = "󰀫",
			Class = "󰠱",
			Interface = "",
			Module = "",
			Property = "󰜢",
			Unit = "",
			Value = "󰎠",
			Enum = "",
			Keyword = "󰌋",
			Snippet = "",
			Color = "󰏘",
			File = "󰈙",
			Reference = "󰈇",
			Folder = "󰉋",
			EnumMember = "",
			Constant = "󰏿",
			Struct = "󰙅",
			Event = "",
			Operator = "󰆕",
			TypeParameter = "",
		}

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("my.lsp.completion", { clear = true }),
			callback = function(ev)
				local client = vim.lsp.get_client_by_id(ev.data.client_id)
				if not client then return end

				if client:supports_method("textDocument/completion") then
					vim.lsp.completion.enable(true, client.id, ev.buf, {
						autotrigger = true,
						convert = function(item)
							local kind_name = vim.lsp.protocol.CompletionItemKind[item.kind] or "Text"
							return {
								abbr = (item.label or ""):gsub("%b()", ""),
								kind = kind_icons[kind_name] or kind_name,
								menu = "[" .. client.name .. "]",
							}
						end,
					})
				end

				if client:supports_method("textDocument/signatureHelp") then
					vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help,
						{ buffer = ev.buf, desc = "LSP signature help" })
				end
			end,
		})

		vim.lsp.enable({
			"bashls",
			"html",
			"jsonls",
			"lua_ls",
			"svelte",
			"sourcekit",
			"tailwindcss",
			"tombi",
			"vtsls",
			"kulala_ls",
			"rust_analyzer",
			"graphql",
		})

		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					telemetry = { enable = false },
					diagnostics = { globals = { "vim", "require" } },
					workspace = { checkThirdParty = false },
				},
			},
		})

		vim.lsp.config("vtsls", {
			settings = {
				typescript = {
					preferences = {
						includeCompletionsForModuleExports = true,
						includeCompletionsForImportStatements = true,
						includeCompletionsWithSnippetText = true,
						includeCompletionsWithInsertText = true,
						importModuleSpecifier = "shortest",
					},
					suggest = {
						completeFunctionCalls = true,
					},
				},
				javascript = {
					preferences = {
						includeCompletionsForModuleExports = true,
						includeCompletionsForImportStatements = true,
						includeCompletionsWithSnippetText = true,
						includeCompletionsWithInsertText = true,
					},
				},
			},
		})

		vim.lsp.document_color.enable(false)

		vim.diagnostic.config({
			virtual_text = false,
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.WARN] = "",
					[vim.diagnostic.severity.INFO] = "",
					[vim.diagnostic.severity.HINT] = "",
				},
			},
			update_in_insert = false,
			underline = true,
			severity_sort = true,
			float = {
				focusable = true,
				style = "minimal",
				border = "rounded",
				source = true,
				header = "",
				prefix = "",
			},
		})
	end,
	defer = true,
	dependencies = {
		{
			defer = true,
			src = "https://github.com/williamboman/mason.nvim",
		},
		{
			defer = true,
			src = "https://github.com/williamboman/mason-lspconfig.nvim",
		},
	},
	src = "https://github.com/neovim/nvim-lspconfig",
}
