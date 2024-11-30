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
-- {
-- 	dir = "~/dev/neovim/colors.nvim",
-- 	dev = true,
-- 	config = function()
-- 		require('vscode').setup({})
-- 		vim.cmd('colorscheme vscode')
-- 	end
-- }

-- }
-- -- Default options:
-- return {
-- 	"ellisonleao/gruvbox.nvim",
-- 	lazy = false,
-- 	priority = 1000,
-- 	config = function()
-- 		require("gruvbox").setup({
-- 			terminal_colors = true, -- add neovim terminal colors
-- 			undercurl = true,
-- 			underline = true,
-- 			bold = true,
-- 			italic = {
-- 				strings = false,
-- 				emphasis = true,
-- 				comments = false,
-- 				operators = false,
-- 				folds = true,
-- 			},
-- 			strikethrough = true,
-- 			invert_selection = false,
-- 			invert_signs = false,
-- 			invert_tabline = false,
-- 			invert_intend_guides = false,
-- 			inverse = true, -- invert background for search, diffs, statuslines and errors
-- 			contrast = "hard", -- can be "hard", "soft" or empty string
-- 			palette_overrides = {},
-- 			overrides = {
-- 				OilDir = { fg = "#83a598" },
-- 			},
-- 			-- dim_inactive = false,
-- 			-- transparent_mode = false,
-- 		})
--
-- 		vim.cmd("colorscheme gruvbox")
--
-- 		-- vim.api.nvim_set_hl(0, "NotifyBackground", { bg = "#000000", ctermbg = "NONE" })
-- 	end,
-- }
--
-- return {
-- 	{
-- 		"nvchad/ui",
-- 		lazy = false,
-- 		priority = 1000,
-- 		config = function()
-- 			require("nvchad")
-- 		end,
-- 	},
--
-- 	{
-- 		"nvchad/base46",
-- 		lazy = false,
-- 		priority = 1000,
-- 		build = function()
-- 			require("base46").load_all_highlights()
-- 		end,
-- 	},
-- }
