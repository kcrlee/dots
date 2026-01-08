return {
	config = function()
		vim.cmd([[colorscheme teide-dimmed]])
	end,
	dependencies = {
		{
			defer = true,
			src = "https://github.com/nvim-lua/plenary.nvim",
		},
	},
	defer = true,
	src = "https://github.com/serhez/teide.nvim",
}
