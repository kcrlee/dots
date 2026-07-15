vim.pack.add({ "https://github.com/dmmulroy/ts-error-translator.nvim" })

require("ts-error-translator").setup({
	-- Auto-attach to LSP servers for TypeScript diagnostics (default: true)
	auto_attach = true,

	-- LSP server names to translate diagnostics for (default shown below)
	servers = {
		"svelte",
		"ts_ls",
	},
})
