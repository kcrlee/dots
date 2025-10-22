local map = vim.keymap.set

map("n", "<F12>", ":UndotreeToggle <Enter>")

map("n", "<leader>i", ":Inspect <Enter>")

map("n", "<leader>ff", ":FzfLua files<Enter>")
map("n", "<leader>fg", ":FzfLua live_grep<Enter>")

map("n", "-", ":Oil<CR>")

map("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", { silent = true, noremap = true })
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { silent = true, noremap = true })
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { silent = true, noremap = true })
map("n", "<leader>g", require("neogit").open)

map("n", "<leader>.", function()
	require("snacks").scratch()
end, { silent = true, noremap = true })

map("n", "<leader>S", function()
	require("snacks").scratch.select()
end, { silent = true, noremap = true })
map("n", "<leader>nn", "<cmd>NoNeckPain<cr>", { silent = true, noremap = true })
