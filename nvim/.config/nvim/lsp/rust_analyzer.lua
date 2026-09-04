local function reload_workspace(bufnr)
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr, name = "rust_analyzer" })) do
		vim.notify("Reloading Cargo workspace")
		client:request("rust-analyzer/reloadWorkspace", nil, function(err)
			if err then
				error(tostring(err))
			end
			vim.notify("Cargo workspace reloaded")
		end, 0)
	end
end

return {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_dir = function(bufnr, on_dir)
		if vim.fn.executable("cargo") ~= 1 then
			vim.notify_once("[rust_analyzer] cargo not found", vim.log.levels.WARN)
			return
		end
		local fname = vim.api.nvim_buf_get_name(bufnr)
		local crate_dir = vim.fs.root(fname, { "Cargo.toml" })
		if not crate_dir then
			on_dir(vim.fs.root(fname, { "rust-project.json" }) or vim.fs.root(fname, { ".git" }))
			return
		end
		-- Ask cargo for the workspace root so a member crate attaches to the
		-- whole workspace instead of just itself.
		local cmd = {
			"cargo",
			"metadata",
			"--no-deps",
			"--format-version",
			"1",
			"--manifest-path",
			crate_dir .. "/Cargo.toml",
		}
		vim.system(cmd, { text = true }, function(out)
			if out.code ~= 0 then
				vim.schedule(function()
					vim.notify(("[rust_analyzer] cargo metadata failed (%d): %s"):format(out.code, out.stderr))
				end)
				return
			end
			local ok, meta = pcall(vim.json.decode, out.stdout or "")
			local ws = ok and meta.workspace_root and vim.fs.normalize(meta.workspace_root) or nil
			on_dir(ws or crate_dir)
		end)
	end,
	capabilities = {
		experimental = { serverStatusNotification = true },
	},
	settings = {
		["rust-analyzer"] = {
			lens = {
				enable = true,
				debug = { enable = true },
				implementations = { enable = true },
				references = {
					adt = { enable = true },
					enumVariant = { enable = true },
					method = { enable = true },
					trait = { enable = true },
				},
				run = { enable = true },
				updateTest = { enable = true },
			},
		},
	},
	before_init = function(init_params, config)
		-- rust-analyzer reads its settings from initializationOptions.
		if config.settings and config.settings["rust-analyzer"] then
			init_params.initializationOptions = config.settings["rust-analyzer"]
		end
	end,
	on_attach = function(_, bufnr)
		vim.api.nvim_buf_create_user_command(bufnr, "LspCargoReload", function()
			reload_workspace(bufnr)
		end, { desc = "Reload current cargo workspace" })
	end,
}
