local util = require("lspconfig.util")

---@type vim.lsp.Config
return {
	cmd = { "graphql-lsp", "server", "-m", "stream" },
	filetypes = { "typescript", "javascript", "graphql", "typescriptreact", "javascriptreact" },
	root_dir = function(bufnr, on_dir)
		local fname = vim.api.nvim_buf_get_name(bufnr)
		on_dir(util.root_pattern(".graphqlrc*", ".graphql.config.*", "graphql.config.*", "package.json")(fname))
	end,
}
