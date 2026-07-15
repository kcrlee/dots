vim.pack.add({
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/rktjmp/lush.nvim", -- library tomorrow-min depends on
	"https://github.com/kcrlee/tomorrow-min",
})

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
