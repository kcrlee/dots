vim.api.nvim_buf_set_keymap(
	0,
	"n",
	"<CR>",
	"<cmd>lua require('kulala').run()<cr>",
	{ noremap = true, silent = true, desc = "Execute the request" }
)
vim.api.nvim_buf_set_keymap(
	0,
	"n",
	"<leader>co",
	"<cmd>lua require('kulala').copy()<cr>",
	{ noremap = true, silent = true, desc = "Copy the current request as a curl command" }
)
vim.api.nvim_buf_set_keymap(
	0,
	"n",
	"<leader>ci",
	"<cmd>lua require('kulala').from_curl()<cr>",
	{ noremap = true, silent = true, desc = "Paste curl from clipboard as http request" }
)
