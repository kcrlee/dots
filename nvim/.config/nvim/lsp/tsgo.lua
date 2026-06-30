local util = require("lspconfig.util")

---@type vim.lsp.Config
return {
	cmd = { "tsgo", "--lsp", "--stdio" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
	},
	root_dir = function(bufnr, on_dir)
		local fname = vim.api.nvim_buf_get_name(bufnr)
		on_dir(
			util.root_pattern("tsconfig.json", "jsconfig.json", "package.json")(fname)
				or vim.fs.dirname(vim.fs.find(".git", { path = fname, upward = true })[1])
		)
	end,
	settings = {
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
			suggest = { autoImports = true },
			updateImportsOnFileMove = { enabled = "always" },
		},
	},
}
