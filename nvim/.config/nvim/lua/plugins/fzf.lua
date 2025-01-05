return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local fzf_lua = require("fzf-lua")
		local actions = require("fzf-lua").actions
		fzf_lua.setup({
			"telescope",
			winopts = {},
			fzf = {
				["ctrl-z"] = "abort",
				["ctrl-q"] = "select-all+accept",
			},
			actions = {
				files = {
					["default"] = actions.file_edit_or_qf,
					["ctrl-s"] = actions.file_split,
					["ctrl-v"] = actions.file_vsplit,
				},
			},
		})
		require("fzf-lua").register_ui_select()
		vim.api.nvim_set_keymap("n", "<leader>ff", [[<Cmd>lua require"fzf-lua".files()<CR>]], {})
		vim.api.nvim_set_keymap("n", "<leader>ff", [[<Cmd>lua require"fzf-lua".files()<CR>]], {})
		vim.api.nvim_set_keymap("n", "<leader>fb", [[<Cmd>lua require"fzf-lua".buffers()<CR>]], {})
		vim.api.nvim_set_keymap("n", "<leader>fg", [[<Cmd>lua require"fzf-lua".live_grep_glob()<CR>]], {})
		vim.api.nvim_set_keymap("n", "<leader>k", [[<Cmd>lua require"fzf-lua".builtin()<CR>]], {})
		vim.api.nvim_set_keymap("n", "<C-g>", [[<Cmd>lua require"fzf-lua".grep_project()<CR>]], {})
		vim.api.nvim_set_keymap("n", "<F1>", [[<Cmd>lua require"fzf-lua".help_tags()<CR>]], {})
	end,
}
