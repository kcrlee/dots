vim.pack.add({ "https://github.com/folke/trouble.nvim" })

local trouble = require("trouble")
trouble.setup({})

local map = vim.keymap.set
map("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", { silent = true, desc = "Trouble quickfix list" })
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { silent = true, desc = "Trouble diagnostics" })
map(
	"n",
	"<leader>xX",
	"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
	{ silent = true, desc = "Trouble buffer diagnostics" }
)
