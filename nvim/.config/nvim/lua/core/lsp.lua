-- lua/core/lsp.lua
vim.lsp.enable({
	"bashls",
	"eslint",
	"expert",
	"hls",
	"html",
	"jsonls",
	"lua_ls",
	"svelte",
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

-- lua_ls, tsgo and rust_analyzer all enable lenses in their settings.
if vim.lsp.codelens.enable then
	vim.lsp.codelens.enable(true)
end

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
