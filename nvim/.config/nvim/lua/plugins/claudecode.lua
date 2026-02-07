return {
	config = function()
		local claudecode = require('claudecode')
		claudecode.setup({
			git_repo_cwd = true,
			config = true,
			terminal = {
				show_native_term_exit_tip = true,
				split_side = "right", -- "left" or "right"
				split_width_percentage = 0.30,
				provider = "auto", -- "auto", "snacks", "native", "external", "none", or custom provider table
				auto_close = true,
				snacks_win_opts = {},
				env = {},
			}
		})
	end,
	src = "https://github.com/coder/claudecode.nvim",
}
