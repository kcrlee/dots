return {
	"akinsho/nvim-toggleterm.lua",
	opts = {
		auto_scroll = true,
		close_on_exit = true,
		hide_numbers = true,
		insert_mappings = false,
		persist_size = true,
		start_in_insert = false,
		terminal_mappings = false,
		size = function(term)
			if term.direction == "horizontal" then
				return 15
			elseif term.direction == "vertical" then
				return vim.o.columns * 0.4
			end
		end,
	},
	config = function(_, opts)
		local toggle_term = require("toggleterm")

		-- Windows
		if vim.fn.has("win32") == 1 then
			opts.shell_command = "pwsh.exe -NoLogo"
		end

		toggle_term.setup(opts)

		vim.keymap.set(
			"n",
			"<leader>tt",
			"<CMD>:ToggleTerm direction=vertical<CR>",
			{ desc = "ToggleTerm: Vertical 1" }
		)
		vim.keymap.set(
			"n",
			"<leader>th",
			"<CMD>:ToggleTerm direction=horizontal<CR>",
			{ desc = "ToggleTerm: Horizontal 2" }
		)
		vim.keymap.set("n", "<leader>tc", "<CMD>:ToggleTermToggleAll<CR>", { desc = "ToggleTerm: Toggle All" })

		function _G.set_terminal_keymaps()
			local opts = { buffer = 0 }
			vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
			vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
			-- vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
			-- vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
			-- vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
			-- vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
			-- vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
		end

		-- if you only want these mappings for toggle term use term://*toggleterm#* instead
		vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
	end,
}
