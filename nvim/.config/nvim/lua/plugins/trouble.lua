return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local trouble = require("trouble")
		trouble.setup({})

		vim.keymap.set("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", { silent = true, noremap = true })
		vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { silent = true, noremap = true })
		vim.keymap.set(
			"n",
			"<leader>xX",
			"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
			{ silent = true, noremap = true }
		)
	end,
}
