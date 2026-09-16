vim.pack.add({ "https://github.com/folke/snacks.nvim" })

local snacks = require("snacks")
snacks.setup({
	image = { enabled = true },
	bigfile = { enabled = true },
	explorer = { enabled = false },
	terminal = { enabled = true },
})

vim.keymap.set("n", "<leader>.", function()
	snacks.scratch()
end, { silent = true, desc = "Snacks toggle scratch buffer" })

vim.keymap.set("n", "<leader>S", function()
	snacks.scratch.select()
end, { silent = true, desc = "Snacks select scratch buffer" })
