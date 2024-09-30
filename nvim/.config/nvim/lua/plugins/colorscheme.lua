return {
	{
		"mofiqul/vscode.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			-- require("vscode").setup({
			-- 	transparent = true,
			-- })
			--
			-- vim.cmd("colorscheme vscode")
			-- vim.api.nvim_set_hl(0, "NotifyBackground", { bg = "#000000", ctermbg = "NONE" })
		end,
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
	},
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
		config = function()
			-- Default options:
			require("kanagawa").setup({
				compile = false, -- enable compiling the colorscheme
				undercurl = true, -- enable undercurls
				commentStyle = { italic = true },
				functionStyle = {},
				keywordStyle = { italic = true },
				statementStyle = { bold = true },
				typeStyle = {},
				transparent = true, -- do not set background color
				dimInactive = false, -- dim inactive window `:h hl-NormalNC`
				terminalColors = true, -- define vim.g.terminal_color_{0,17}
				colors = { -- add/modify theme and palette colors
					palette = {},
					theme = {
						wave = {},
						lotus = {},
						dragon = {},
						all = {
							ui = {
								bg_gutter = "none",
							},
						},
					},
				},
				overrides = function(colors) -- add/modify highlights
					return {}
				end,
				theme = "wave", -- Load "wave" theme when 'background' option is not set
				background = { -- map the value of 'background' option to a theme
					dark = "wave", -- try "dragon" !
					light = "lotus",
				},
			})

			-- setup must be called before loading
			-- vim.cmd("colorscheme kanagawa")
		end,
	},
	{
		"kepano/flexoki-neovim",
		lazy = false,
		priority = 1000,
		opts = {},
		config = function()
			-- 	vim.cmd("colorscheme flexoki-dark")
			-- 	vim.api.nvim_set_hl(0, "NotifyBackground", { bg = "#000000", ctermbg = "NONE" })
			-- 	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
			-- 	vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
			-- 	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
			-- 	vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none", ctermbg = "NONE" })
			-- 	vim.api.nvim_set_hl(0, "SignColumn", { bg = "none", ctermbg = "NONE" })
			-- 	vim.api.nvim_set_hl(0, "StatusLine", { bg = "none", ctermbg = "NONE" })
			-- 	vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "none", ctermbg = "NONE" })
			-- 	vim.api.nvim_set_hl(0, "TabLineFill", { bg = "none", ctermbg = "NONE" })
		end,
	},
	{
		"Yazeed1s/minimal.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
		config = function()
			vim.cmd([[colorscheme minimal-base16]])
			vim.api.nvim_set_hl(0, "NotifyBackground", { bg = "#000000", ctermbg = "NONE" })
			vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
			vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
			vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
			vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none", ctermbg = "NONE" })
			vim.api.nvim_set_hl(0, "SignColumn", { bg = "none", ctermbg = "NONE" })
			vim.api.nvim_set_hl(0, "StatusLine", { bg = "none", ctermbg = "NONE" })
			vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "none", ctermbg = "NONE" })
			vim.api.nvim_set_hl(0, "TabLineFill", { bg = "none", ctermbg = "NONE" })
			vim.api.nvim_set_hl(0, "Gutter", { bg = "none", ctermbg = "NONE" })
		end,
	},
}
