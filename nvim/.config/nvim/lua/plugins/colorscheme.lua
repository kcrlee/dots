return {
	config = function()
		vim.cmd([[colorscheme tomorrow-min]])

		local function flatten_float_hls()
			vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
			vim.api.nvim_set_hl(0, "FloatBorder", { link = "Normal" })
			vim.api.nvim_set_hl(0, "@markup.raw.block.markdown", { bg = "NONE" })
			vim.api.nvim_set_hl(0, "@markup.raw.delimiter.markdown", { bg = "NONE" })
			vim.api.nvim_set_hl(0, "@markup.raw.markdown_inline", { bg = "NONE" })
		end
		vim.api.nvim_create_autocmd("ColorScheme", {
			group = vim.api.nvim_create_augroup("my.float.bg", { clear = true }),
			callback = flatten_float_hls,
		})
		flatten_float_hls()
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
