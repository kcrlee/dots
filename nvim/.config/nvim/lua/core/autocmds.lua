vim.cmd([[autocmd BufEnter * set formatoptions-=cro]])

vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile", "BufWritePost" }, {
	callback = function()
		require("lint").try_lint()
	end,
})
