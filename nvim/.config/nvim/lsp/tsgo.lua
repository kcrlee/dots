return {
	cmd = function(dispatchers, config)
		local root = (config or {}).root_dir
		local candidates = {}
		if root then
			vim.list_extend(candidates, {
				vim.fs.joinpath(root, "node_modules/.bin/tsgo"),
				vim.fs.joinpath(root, "node_modules/.bin/tsc"),
			})
		end
		vim.list_extend(candidates, { "tsgo", "tsc" })
		for _, bin in ipairs(candidates) do
			if vim.fn.executable(bin) == 1 then
				return vim.lsp.rpc.start({ bin, "--lsp", "--stdio" }, dispatchers)
			end
		end
		error("tsgo: no tsgo/tsc binary found (TypeScript 7+ required)")
	end,
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	root_dir = function(bufnr, on_dir)
		local project_root = vim.fs.root(bufnr, {
			{ "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" },
			{ ".git" },
		})
		-- Don't start inside a Deno project.
		local deno_root = vim.fs.root(bufnr, { "deno.json", "deno.jsonc", "deno.lock" })
		if deno_root and (not project_root or #deno_root >= #project_root) then
			return
		end
		on_dir(project_root or vim.fn.getcwd())
	end,
	settings = {
		["js/ts"] = {
			inlayHints = {
				parameterNames = { enabled = "literals", suppressWhenArgumentMatchesName = true },
				parameterTypes = { enabled = true },
				variableTypes = { enabled = true },
				propertyDeclarationTypes = { enabled = true },
				functionLikeReturnTypes = { enabled = true },
				enumMemberValues = { enabled = true },
			},
			referencesCodeLens = { enabled = true, showOnAllFunctions = true },
			implementationsCodeLens = { enabled = true, showOnInterfaceMethods = true, showOnAllClassMethods = true },
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
					"dist/**",
					"**/.tanstack/**",
					"**/generated/**",
					"**/packages/gql/dist/**",
				},
			},
			suggest = { completeFunctionCalls = true, autoImports = true },
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
