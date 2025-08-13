-- return {
-- 	"Mofiqul/vscode.nvim",
-- 	config = function()
-- 		local code = require("vscode").setup({})
-- 		vim.o.background = "dark"
-- 		vim.cmd("colorscheme vscode")
-- 	end,
-- }
return {
	dir = "~/dev/personal/nvim-plugins/tomorrow-min",
	-- "KyleLee95/tomorrow-min",
	lazy = false,
	config = function()
		vim.cmd("colorscheme tomorrow-min")
	end,
}

-- return {
-- 	"armannikoyan/rusty",
-- 	lazy = false,
-- 	priority = 1000,
-- 	opts = {
-- 		transparent = true,
-- 		italic_comments = true,
-- 		underline_current_line = true,
-- 	},
-- 	config = function(_, opts)
-- 		require("rusty").setup(opts)
-- 		vim.cmd("colorscheme rusty")
-- 	end,
-- }
