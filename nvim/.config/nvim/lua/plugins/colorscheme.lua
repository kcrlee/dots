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
