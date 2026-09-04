return {
	cmd = function(dispatchers, config)
		local cmd = "svelteserver"
		local root = (config or {}).root_dir
		if root then
			local local_cmd = vim.fs.joinpath(root, "node_modules/.bin", cmd)
			if vim.fn.executable(local_cmd) == 1 then
				cmd = local_cmd
			end
		end
		return vim.lsp.rpc.start({ cmd, "--stdio" }, dispatchers)
	end,
	filetypes = { "svelte" },
	root_dir = function(bufnr, on_dir)
		-- The server only accepts file:// URIs, so skip unsaved/virtual buffers.
		-- https://github.com/sveltejs/language-tools/issues/2777
		if vim.uv.fs_stat(vim.api.nvim_buf_get_name(bufnr)) == nil then
			return
		end
		local root = vim.fs.root(bufnr, {
			{ "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock", "deno.lock" },
			{ ".git" },
		})
		on_dir(root or vim.fn.getcwd())
	end,
	settings = {
		typescript = {
			inlayHints = {
				parameterNames = { enabled = "literals", suppressWhenArgumentMatchesName = true },
				parameterTypes = { enabled = true },
				variableTypes = { enabled = true },
				propertyDeclarationTypes = { enabled = true },
				functionLikeReturnTypes = { enabled = true },
				enumMemberValues = { enabled = true },
			},
		},
	},
	on_attach = function(client, bufnr)
		-- Tell the server about edited .js/.ts files it doesn't own.
		-- https://github.com/sveltejs/language-tools/issues/2008
		vim.api.nvim_create_autocmd("BufWritePost", {
			pattern = { "*.js", "*.ts" },
			group = vim.api.nvim_create_augroup("lsp.svelte", {}),
			callback = function(ctx)
				client:notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
			end,
		})
		vim.api.nvim_buf_create_user_command(bufnr, "LspMigrateToSvelte5", function()
			client:exec_cmd({
				title = "Migrate Component to Svelte 5 Syntax",
				command = "migrate_to_svelte_5",
				arguments = { vim.uri_from_bufnr(bufnr) },
			})
		end, { desc = "Migrate Component to Svelte 5 Syntax" })
	end,
}
