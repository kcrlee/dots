vim.pack.add({ "https://github.com/neogitorg/neogit" })

vim.keymap.set("n", "<leader>g", function()
	require("neogit").open()
end, { silent = true, desc = "Neogit open" })
