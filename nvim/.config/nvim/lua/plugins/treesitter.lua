return {
	config = function()
		require("tree-sitter-manager").setup({
			ensure_installed = {
				"bash",
				"c",
				"dockerfile",
				"graphql",
				"git_config",
				"git_rebase",
				"gitattributes",
				"gitcommit",
				"gitignore",
				"go",
				"gomod",
				"gosum",
				"html",
				"javascript",
				"css",
				"json",
				"jsx",
				"lua",
				"liquid",
				"make",
				"markdown",
				"python",
				"sql",
				"toml",
				"tsx",
				"typescript",
				"yaml",
				"vim",
				"zig",
			},         -- parsers to install at startup
			border = "rounded", -- border style for the TUI window
		})
	end,
	defer = true,
	dependencies = {
		{
			defer = true,
			src = "https://github.com/romus204/tree-sitter-manager.nvim",
			version = "main",
		},
	},
	src = "https://github.com/nvim-treesitter/nvim-treesitter",
	version = "main",
}
