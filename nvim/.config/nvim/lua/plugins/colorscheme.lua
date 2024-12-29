-- return {
-- 	"Mofiqul/vscode.nvim",
-- 	lazy = false,
-- 	config = function()
-- 		local code = require("vscode")
-- 		code.setup({
-- 			-- Enable transparent background
-- 			transparent = true,
-- 		})
-- 		vim.cmd.colorscheme("vscode")
-- 	end,
-- }

-- return {
-- 	"ntk148v/habamax.nvim",
-- 	dependencies = { "rktjmp/lush.nvim" },
-- 	lazy = false,
-- 	config = function()
-- 		vim.cmd("colorscheme habamax.nvim")
-- 	end,
-- }

return {
	dir = "~/dev/code-minimal",
	lazy = false,
	config = function()
		vim.cmd("colorscheme code-minimal")
	end,
}
