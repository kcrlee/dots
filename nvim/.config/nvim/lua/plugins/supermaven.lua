return {
	"supermaven-inc/supermaven-nvim",
	config = function()
		require("supermaven-nvim").setup({
			keymaps = {
				accept_suggestion = "<C-g>",
				clear_suggestion = "<C-]>",
			},
			disable_inline_completion = true, -- disables inline completion for use with cmp
			ignore_filetypes = { markdown = true },
		})
	end,
}
