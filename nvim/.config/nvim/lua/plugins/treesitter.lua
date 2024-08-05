return {
	"nvim-treesitter/nvim-treesitter",
	version = false, -- last release is way too old and doesn't work on Windows
	build = ":TSUpdate",
	dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		require("ts_context_commentstring").setup({})
		local configs = require("nvim-treesitter.configs")
		configs.setup({
			ensure_installed = {
				"c",
				"cpp",
				"cuda",
				"haskell",
				"lua",
				"markdown",
				"markdown_inline",
				"latex",
				"nix",
				"vim",
				"html",
				"javascript",
				"typescript",
			},
			highlight = { enable = true },
			indent = { enable = true, ignore = { "python" } },
		})
	end,
}
