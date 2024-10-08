-- return {
-- 	{
-- 		"mofiqul/vscode.nvim",
-- 		lazy = false,
-- 		priority = 1000,
-- 		config = function()
-- 			require("vscode").setup({
-- 				transparent = true,
-- 			})
--
-- 			vim.cmd("colorscheme vscode")
-- 			vim.api.nvim_set_hl(0, "NotifyBackground", { bg = "#000000", ctermbg = "NONE" })
-- 		end,
-- 	},
-- }

-- Default options:
return {
	"ellisonleao/gruvbox.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("gruvbox").setup({
			terminal_colors = true, -- add neovim terminal colors
			undercurl = true,
			underline = true,
			bold = true,
			italic = {
				strings = false,
				emphasis = true,
				comments = false,
				operators = false,
				folds = true,
			},
			strikethrough = true,
			invert_selection = false,
			invert_signs = false,
			invert_tabline = false,
			invert_intend_guides = false,
			inverse = true, -- invert background for search, diffs, statuslines and errors
			contrast = "", -- can be "hard", "soft" or empty string
			palette_overrides = {},
			overrides = {},
			dim_inactive = false,
			transparent_mode = true,
		})

		vim.cmd("colorscheme gruvbox")

		vim.api.nvim_set_hl(0, "NotifyBackground", { bg = "#000000", ctermbg = "NONE" })
	end,
}
