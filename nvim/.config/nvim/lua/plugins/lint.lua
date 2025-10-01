return {
	config = function()
		local lint = require("lint")
		vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile", "BufWritePost" }, {
			callback = function()
				require("lint").try_lint()
			end,
		})
	end,
	defer = true,
	src = "https://github.com/mfussenegger/nvim-lint",
}
