return {
	"Mofiqul/vscode.nvim",
	lazy = false,
	config = function()
		local code = require("vscode")
		code.setup({
			-- Enable transparent background
			transparent = true,
		})
		vim.cmd.colorscheme("vscode")
	end,
}

-- return {
-- 	dir = "~/dev/harbor",
-- 	dev = true,
-- 	lazy = false,
-- 	config = function()
-- 		-- require("harbor").setup({})
-- 		vim.cmd("colorscheme harbor")
-- 	end,
-- }
