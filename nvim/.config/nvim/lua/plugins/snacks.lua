vim.pack.add({ "https://github.com/folke/snacks.nvim" })

local snacks = require("snacks")
snacks.setup({
	image = { enabled = true },
	bigfile = { enabled = true },
	explorer = { enabled = false },
	terminal = { enabled = true }
})
