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

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("my.lsp.attach", { clear = true }),
			callback = function(ev)
				local client = vim.lsp.get_client_by_id(ev.data.client_id)
				if not client then return end

				if client:supports_method("textDocument/hover") then
					vim.keymap.set("n", "K", function()
						vim.lsp.buf.hover({
							border = "rounded",
							max_width = 80,
							max_height = 20,
						})
					end, { buffer = ev.buf, desc = "LSP hover" })
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
			'tsgo',
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
				vtsls = {
					autoUseWorkspaceTsdk = true,
					experimental = {
						completion = {
							enableServerSideFuzzyMatch = true,
							entriesLimit = 100,
						},
					},
				},
				typescript = {
					tsserver = { maxTsServerMemory = 8192 },
					preferences = {
						includeCompletionsForModuleExports = true,
						includeCompletionsForImportStatements = true,
						includeCompletionsWithSnippetText = true,
						includeCompletionsWithInsertText = true,
						includePackageJsonAutoImports = "auto",
						importModuleSpecifier = "shortest",
						autoImportFileExcludePatterns = {
							"**/node_modules/**",
							"**/dist/**",
							"**/.tanstack/**",
							"**/generated/**",
							"**/packages/gql/dist/**",
						},
					},
					suggest = {
						completeFunctionCalls = true,
						autoImports = true,
					},
					updateImportsOnFileMove = { enabled = "always" },
				},
				javascript = {
					tsserver = { maxTsServerMemory = 8192 },
					preferences = {
						includeCompletionsForModuleExports = true,
						includeCompletionsForImportStatements = true,
						includeCompletionsWithSnippetText = true,
						includeCompletionsWithInsertText = true,
						includePackageJsonAutoImports = "auto",
					},
					suggest = {
						autoImports = true,
					},
					updateImportsOnFileMove = { enabled = "always" },
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
