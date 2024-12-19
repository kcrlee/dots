return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim", -- required
		"sindrets/diffview.nvim", -- optional - Diff integration
		-- Only one of these is needed.
		"nvim-telescope/telescope.nvim", -- optional
	},
	config = function()
		local neogit = require("neogit")
		local function open_neogit_cwd()
			neogit.open({ cwd = vim.fn.expand("%:p:h") })
		end
		vim.keymap.set("n", "<leader>g", open_neogit_cwd, {})
	end,
}
