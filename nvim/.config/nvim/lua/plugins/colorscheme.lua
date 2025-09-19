return {
	dir = "~/dev/personal/nvim-plugins/tomorrow-min",
	-- "KyleLee95/tomorrow-min",
	lazy = false,
	config = function()
		vim.cmd("colorscheme tomorrow-min")
	end,
}

-- return {
-- 	"marko-cerovac/material.nvim",
-- 	lazy = false,
-- 	config = function()
-- 		vim.g.material_style = "darker"
-- 		vim.cmd("colorscheme material ")
-- 	end,
-- }

-- return {
-- 	"ntk148v/habamax.nvim",
-- 	dependencies = { "rktjmp/lush.nvim" },
-- 	config = function()
-- 		vim.cmd.colorscheme("habamax.nvim")
-- 	end,
-- }

-- return {
-- 	"kepano/flexoki-neovim",
-- 	config = function()
-- 		vim.cmd("colorscheme flexoki-dark")
-- 	end,
-- }
