return {
	config = function()
		local snacks = require("snacks")
		snacks.setup({
			image = { enabled = false },
			bigfile = { enabled = true },
			explorer = { enabled = false },
			terminal = { enabled = true }
		})
	end,
	defer = true,
	src = "https://github.com/folke/snacks.nvim",
}
