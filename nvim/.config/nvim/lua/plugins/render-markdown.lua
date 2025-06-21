return {
	"MeanderingProgrammer/render-markdown.nvim",
	opts = {
		code = {
			sign = true,
			width = "block",
			right_pad = 1,
		},
		heading = {
			sign = true,
			icons = {},
		},
		checkbox = {
			enabled = true,
		},
	},
	ft = { "markdown", "norg", "rmd", "org" },
	config = function(_, opts)
		require("render-markdown").setup(opts)
	end,
}
