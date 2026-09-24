vim.pack.add({
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/WTFox/luna.nvim",
	"https://github.com/kcrlee/yesterday.nvim",
})

vim.cmd([[colorscheme yesterday]])

-- local function flatten_float_hls()
-- 	vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
-- 	vim.api.nvim_set_hl(0, "FloatBorder", { link = "Normal" })
-- 	vim.api.nvim_set_hl(0, "@markup.raw.block.markdown", { bg = "NONE" })
-- 	vim.api.nvim_set_hl(0, "@markup.raw.delimiter.markdown", { bg = "NONE" })
-- 	vim.api.nvim_set_hl(0, "@markup.raw.markdown_inline", { bg = "NONE" })
-- end
-- vim.api.nvim_create_autocmd("ColorScheme", {
-- 	group = vim.api.nvim_create_augroup("my.float.bg", { clear = true }),
-- 	callback = flatten_float_hls,
-- })
-- flatten_float_hls()
