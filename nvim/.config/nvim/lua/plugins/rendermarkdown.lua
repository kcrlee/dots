vim.pack.add({ "https://github.com/MeanderingProgrammer/render-markdown.nvim" })

require("render-markdown").setup({
	code = {
		style = "language",
		border = "thin",
		highlight = "Normal",
		highlight_inline = "Normal",
	},
	heading = {
		backgrounds = {},
	},
})
