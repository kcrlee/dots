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
	"tsc",
	"tombi",
	"kulala_ls",
	"rust_analyzer",
	"graphql",
	"vue_ls",
})

vim.lsp.document_color.enable(false)

-- No ghost text from the LSP: inlay hints (`: Type`, `param:`) and code lens
-- (`N references`). Toggle on demand with
-- :lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
vim.lsp.inlay_hint.enable(false)
vim.lsp.codelens.enable(false)

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
