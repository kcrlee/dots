return {
	{
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
	},
	{

		"rebelot/kanagawa.nvim",
		lazy = false,
		config = function()
			local kanagawa = require("kanagawa")
			kanagawa.setup({
				transparent = true,
				compile = true,
				colors = {
					palette = {
						fujiWhite = "#EDE6C4", -- Default foreground (brighter)
						oldWhite = "#D2C58A", -- Dark foreground (statuslines, slightly brighter)
						sumiInk0 = "#101016", -- Darker background
						sumiInk1 = "#1A1A20", -- Default background (darker)
						sumiInk2 = "#24242F", -- Lighter background (colorcolumn, folds)
						sumiInk3 = "#2E2E40", -- Lighter background (cursorline)
						sumiInk4 = "#4A4A60", -- Darker foreground (line numbers, borders)
						waveBlue1 = "#1A283B", -- Popup background, visual selection background
						waveBlue2 = "#235370", -- Popup selection background, search background
						winterGreen = "#243120", -- Diff Add (background)
						winterYellow = "#3E372E", -- Diff Change (background)
						winterRed = "#3A1F26", -- Diff Deleted (background)
						winterBlue = "#1D1D28", -- Diff Line (background)
						autumnGreen = "#87B774", -- Git Add (brighter green)
						autumnRed = "#D64A48", -- Git Delete (brighter red)
						autumnYellow = "#E3B079", -- Git Change (brighter yellow)
						samuraiRed = "#F02424", -- Diagnostic Error (brighter red)
						roninYellow = "#FFA445", -- Diagnostic Warning (brighter yellow)
						waveAqua1 = "#79A59A", -- Diagnostic Info (brighter aqua)
						dragonBlue = "#7396A3", -- Diagnostic Hint (brighter blue)
						fujiGray = "#828071", -- Comments (slightly brighter)
						springViolet1 = "#A19ABD", -- Light foreground (brighter violet)
						oniViolet = "#A282C8", -- Statements and Keywords (brighter violet)
						crystalBlue = "#8EB0EB", -- Functions and Titles (brighter blue)
						springViolet2 = "#ADC3DB", -- Brackets and punctuation (brighter violet)
						springBlue = "#89C9DB", -- Specials and builtin functions (brighter blue)
						lightBlue = "#B7E5E6", -- Not used (brighter)
						waveAqua2 = "#86B6A7", -- Types (brighter aqua)
						springGreen = "#A9D47B", -- Strings (brighter green)
						boatYellow1 = "#A39067", -- Not used (brighter yellow)
						boatYellow2 = "#D1B37A", -- Operators, RegEx (brighter yellow)
						carpYellow = "#F2D397", -- Identifiers (brighter yellow)
						sakuraPink = "#E28EA9", -- Numbers (brighter pink)
						waveRed = "#F47A89", -- Standout specials 1 (brighter red)
						peachRed = "#FF7378", -- Standout specials 2 (brighter peach)
						surimiOrange = "#FFB278", -- Constants, imports, booleans (brighter orange)
						katanaGray = "#8A9393", -- Deprecated (brighter gray)

						dragonBlack0 = "#080808", -- Deep black for strong contrast
						dragonBlack1 = "#0E0E0C",
						dragonBlack2 = "#151511",
						dragonBlack3 = "#201F1F",
						dragonBlack4 = "#2A2929",
						dragonBlack5 = "#454241",
						dragonBlack6 = "#837E7B", -- Dark-muted foreground

						dragonWhite = "#FFFFFA", -- Maximum brightness white
						dragonGreen = "#BFFFAB", -- Extremely vibrant green
						dragonGreen2 = "#D2F59A",
						dragonPink = "#E0A6E4", -- Bold, intense pink
						dragonOrange = "#FFB48A", -- Rich, fiery orange
						dragonOrange2 = "#FFB083",
						dragonGray = "#D6D6C9", -- Bright and clean gray
						dragonGray2 = "#CFCBBF",
						dragonGray3 = "#9EAAA9",
						dragonBlue2 = "#B7E8FF", -- Electric blue
						dragonViolet = "#C7C1FF", -- Vibrant violet
						dragonRed = "#FF9694", -- Eye-catching red
						dragonAqua = "#B8FFF5", -- Bold aqua
						dragonAsh = "#A1B2A1", -- Slightly brighter ash
						dragonTeal = "#C0D6FF", -- Saturated teal
						dragonYellow = "#FFE1A3", -- Vibrant yellow
					},
					theme = {
						all = {
							ui = {
								bg_gutter = "none",
							},
						},
					},
				},
				overrides = function(colors)
					local theme = colors.theme
					return {
						NormalFloat = { bg = "none" },
						FloatBorder = { bg = "none" },
						FloatTitle = { bg = "none" },
						Function = { fg = "none" },

						-- Save an hlgroup with dark background and dimmed foreground
						-- so that you can use it where your still want darker windows.
						-- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
						NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

						-- Popular plugins that open floats will link to NormalFloat by default;
						-- set their background accordingly if you wish to keep them dark and borderless
						LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
						MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
					}
				end,
			})
			vim.cmd("colorscheme kanagawa-dragon")
		end,
	},
}
