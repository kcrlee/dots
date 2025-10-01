return {
	config = function()
		local lazydev = require("lazydev")
		lazydev.setup({
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		})
	end,
	defer = true,
	src = "https://github.com/folke/lazydev.nvim",
}
