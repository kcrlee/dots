vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter-context" })

local treesitter_ctx = require("treesitter-context")
treesitter_ctx.setup({
	max_lines = 2,
	separator = "-",
	mode = "topline",
})
