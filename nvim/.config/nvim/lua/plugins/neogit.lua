return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"sindrets/diffview.nvim",
		"ibhagwan/fzf-lua",
	},
	config = function()
		local neogit = require("neogit")

		-- open using defaults
		vim.keymap.set("n", "<leader>g", function()
			neogit.open()
		end)
	end,
}
