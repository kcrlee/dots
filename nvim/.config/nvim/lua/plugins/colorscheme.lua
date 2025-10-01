return {
	config = function()
		vim.cmd([[colorscheme tomorrow-min]])
	end,
	dependencies = {
		{
			defer = true,
			src = "https://github.com/rktjmp/lush.nvim",
		},
	},
	defer = true,
	src = "https://github.com/kcrlee/tomorrow-min",
}
