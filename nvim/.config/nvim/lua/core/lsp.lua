-- lua/core/lsp.lua
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
	"tsgo",
	"tombi",
	"kulala_ls",
	"rust_analyzer",
	"graphql",
	"vue_ls",
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
