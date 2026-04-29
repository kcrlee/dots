return {
	config = function()
		local noice = require('noice')
		noice.setup({
			lsp = {
				hover = { enabled = false },
				signature = { enabled = false },
				message = { enabled = true },
				progress = { enabled = true },
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
			},
		})
	end,
	defer = true,
	src = "https://github.com/folke/noice.nvim"
}
