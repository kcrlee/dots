return {
	config = function()
		vim.cmd([[colorscheme tomorrow-min]])

		vim.api.nvim_create_autocmd("ColorScheme", {
			group = vim.api.nvim_create_augroup("my.float.bg", { clear = true }),
			callback = function()
				vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
				vim.api.nvim_set_hl(0, "FloatBorder", { link = "Normal" })
			end,
		})
		vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
		vim.api.nvim_set_hl(0, "FloatBorder", { link = "Normal" })
	end,
	dependencies = {
		{
			defer = true,
			src = "https://github.com/nvim-lua/plenary.nvim",
		},
		{
			defer = true,
			src = "https://github.com/rktjmp/lush.nvim",
		},
	},
	defer = true,
	src = "https://github.com/kcrlee/tomorrow-min",
}
