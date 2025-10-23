---@type vim.lsp.Config
return {
	cmd = { "lua-language-server" },
	filetypes = { 'lua' },
	root_markers = {
		'luarc.json',
		'.luarc.json',
		'.git'
	},
	settings = {
		Lua = {
			hint = { enable = true },
			telemetry = { enable = false },
			diagnostics = { globals = { "vim" } },
			workspace = {
				checkThirdParty = false,
				-- library = vim.api.nvim_get_runtime_file("", true),
			},
		},
	},
}
