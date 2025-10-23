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
			diagnostics = { globals = { "vim", "require" } },
			workspace = {
				checkThirdParty = false,
			},
		},
	},
}
