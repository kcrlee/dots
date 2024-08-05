return {
	"mofiqul/vscode.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("vscode").setup({
			transparent = true,
		})
		vim.cmd("colorscheme vscode")
		vim.api.nvim_set_hl(0, "NotifyBackground", { bg = "#000000", ctermbg = "NONE" })
	end,
}
