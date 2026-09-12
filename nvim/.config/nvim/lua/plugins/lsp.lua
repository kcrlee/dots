vim.pack.add({
	"https://github.com/williamboman/mason.nvim",
	"https://github.com/williamboman/mason-lspconfig.nvim",
	"https://github.com/neovim/nvim-lspconfig",
})

require("mason").setup({
	registries = { "github:crashdummyy/mason-registry", "github:mason-org/mason-registry" },
})
require("mason-lspconfig").setup()

-- blink.lua loads before this file (plugins load alphabetically)
vim.lsp.config("*", {
	capabilities = require("blink.cmp").get_lsp_capabilities(),
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
	"shopify_theme_ls",
	"tailwindcss",
	"tsc",
	"tombi",
	"kulala_ls",
	"rust_analyzer",
	"graphql",
	"vue_ls",
})

-- Deltas for servers nvim-lspconfig ships. These must be vim.lsp.config()
-- calls, not lsp/*.lua files: plugin lsp/ files win the runtimepath merge,
-- while config() calls take precedence over all runtime files.
vim.lsp.config("html", {
	cmd = { "vscode-html-language-server", "--stdio" },
	filetypes = { "html", "htmldjango" },
})

vim.lsp.config("hls", {
	filetypes = { "haskell", "lhaskell", "cabal" },
	settings = {
		haskell = { formattingProvider = "fourmolu" },
	},
})

vim.lsp.config("graphql", {
	filetypes = { "typescript", "javascript", "graphql", "typescriptreact", "javascriptreact" },
	root_dir = function(bufnr, on_dir)
		local fname = vim.api.nvim_buf_get_name(bufnr)
		local util = require("lspconfig.util")
		on_dir(util.root_pattern(".graphqlrc*", ".graphql.config.*", "graphql.config.*", "package.json")(fname))
	end,
})

vim.lsp.config("sourcekit", {
	cmd = { "xcrun", "sourcekit-lsp" },
})

vim.lsp.config("tsc", {
	-- Only keys the TypeScript 7 native server reads (see its js/ts,
	-- typescript, javascript config sections). tsserver-era keys such as
	-- maxTsServerMemory, updateImportsOnFileMove, and completeFunctionCalls
	-- are ignored by the Go implementation.
	settings = {
		typescript = {
			preferences = {
				importModuleSpecifier = "shortest",
				autoImportFileExcludePatterns = {
					"dist/**",
					"**/.tanstack/**",
					"**/generated/**",
					"**/packages/gql/dist/**",
				},
			},
			suggest = {
				autoImports = true,
				includeCompletionsForImportStatements = true,
			},
		},
		javascript = {
			preferences = { importModuleSpecifier = "shortest" },
			suggest = {
				autoImports = true,
				includeCompletionsForImportStatements = true,
			},
		},
	},
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
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "",
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
