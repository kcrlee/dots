vim.pack.add({
	{
		src = "https://www.github.com/olimorris/codecompanion.nvim",
		version = vim.version.range("^19.0.0"),
	},
})

require("codecompanion").setup({
	interactions = {
		chat = {
			adapter = "anthropic",
			model = "claude-sonnet-4-20250514",
		},
	},
	opts = {
		log_level = "DEBUG",
	},
})
