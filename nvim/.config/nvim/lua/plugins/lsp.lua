return {
	config = function()
		local autocmd = vim.api.nvim_create_autocmd
		local augroup = vim.api.nvim_create_augroup("config", { clear = true })
		vim.lsp.enable({
			"bashls",
			"cssls",
			"html",
			"jsonls",
			"lua_ls",
			"shopify_theme_ls",
			"svelte",
			"tailwindcss",
			"rust_analyzer",
			"ts_ls",
			"typos_lsp",
			"graphql",
		})

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
	},
	src = "https://github.com/neovim/nvim-lspconfig",
}
