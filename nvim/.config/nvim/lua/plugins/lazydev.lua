return {
	config = function()
		require("lazydev").setup({
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				{ path = "wezterm-types",      mods = { "wezterm" } },
			},
		})
	end,
	dependencies = {
		{ src = "https://github.com/DrKJeff16/wezterm-types" },
	},
	src = "https://github.com/folke/lazydev.nvim",
}
