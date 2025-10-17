return {
	config = function()
		local autocmd = vim.api.nvim_create_autocmd
		local ts = require("nvim-treesitter")
		require("nvim-treesitter").setup({
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
			},
			highlight = { enable = true },
			indent = { enable = true },
		})
	end,
	defer = true,
	dependencies = {
		{
			defer = true,
			src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
			version = "main",
		},
	},
	src = "https://github.com/nvim-treesitter/nvim-treesitter",
	version = "main",
}
