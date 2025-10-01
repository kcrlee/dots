return {
	config = function()
		local treesitter_ctx = require("treesitter-context")
		treesitter_ctx.setup({
			max_lines = 2,
			separator = "-",
			mode = "topline",
		})
	end,
	defer = true,
	src = "https://github.com/nvim-treesitter/nvim-treesitter-context",
}
