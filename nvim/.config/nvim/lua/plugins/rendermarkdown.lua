return {
	config = function()
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
	end,
	defer = true,
	src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim',
}
