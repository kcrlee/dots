return {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	-- Nested lists are priority tiers: nearest match within a tier wins,
	-- earlier tiers beat later ones.
	root_markers = {
		{ ".emmyrc.json", ".luarc.json", ".luarc.jsonc" },
		{ ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml" },
		{ ".git" },
	},
	settings = {
		Lua = {
			codeLens = { enable = true },
			hint = { enable = true, semicolon = "Disable" },
			telemetry = { enable = false },
			diagnostics = { globals = { "vim", "require" } },
			workspace = { checkThirdParty = false },
		},
	},
}
