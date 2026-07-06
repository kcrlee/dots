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

		vim.lsp.enable({
			"bashls",
			"expert",
			"hls",
			"html",
			"jsonls",
			"lua_ls",
			"svelte",
			"sourcekit",
			"tailwindcss",
			"tombi",
			"kulala_ls",
			"rust_analyzer",
			"graphql",
			"tsgo",
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
