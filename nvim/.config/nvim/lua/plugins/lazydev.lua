vim.pack.add({
	"https://github.com/DrKJeff16/wezterm-types",
	"https://github.com/folke/lazydev.nvim",
})

require("lazydev").setup({
	library = {
		{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
		{ path = "wezterm-types",      mods = { "wezterm" } },
	},
})
