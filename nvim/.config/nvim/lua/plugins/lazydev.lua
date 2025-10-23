return {
	config = function()
		local lazydev = require("lazydev")
		lazydev.setup({
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				{ path = "wezterm-types",      mods = { "wezterm" } },
			},
		})
	end,
	dependencies = {
		src = "https://github.com/DrKJeff16/wezterm-types",
		defer = true,
	},
	defer = true,
	src = "https://github.com/folke/lazydev.nvim",
}
