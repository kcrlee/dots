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
				"zig",
			},
			highlight = { enable = true, additional_vim_regex = false },
			indent = { enable = true },
		})
		autocmd("PackChanged", {
			group = 'init',
			callback = function(ev)
				local spec = ev.data.spec
				if spec and spec.name == "nvim-treesitter" and ev.data.kind == "update" then
					vim.schedule(function()
						ts.update()
					end)
				end
			end,
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
