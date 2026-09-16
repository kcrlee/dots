-- Tomorrow Night rendered through base16-nvim's highlight definitions.
-- Palette source of truth is tomorrow-min; base04/base06/base0F have no
-- equivalent there, so they use the canonical base16-tomorrow-night values.
vim.cmd("highlight clear")
vim.g.colors_name = "tomorrow-base16"

local c = require("tomorrow-min.colors").base

require("base16-colorscheme").setup({
	base00 = c.bg, -- default background
	base01 = c.line, -- lighter background (status bars)
	base02 = c.selection, -- selection background
	base03 = c.comment, -- comments, invisibles
	base04 = "#b4b7b4", -- dark foreground (status bars)
	base05 = c.fg, -- default foreground
	base06 = "#e0e0e0", -- light foreground
	base07 = c.white, -- light background
	base08 = c.red, -- variables, tags, diff deleted
	base09 = c.orange, -- integers, booleans, constants
	base0A = c.yellow, -- classes, search background
	base0B = c.green, -- strings, diff added
	base0C = c.aqua, -- regex, escapes
	base0D = c.blue, -- functions, headings
	base0E = c.purple, -- keywords, diff changed
	base0F = "#a3685a", -- deprecated, embedded punctuation
})
