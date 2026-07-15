vim.pack.add({
	"https://github.com/MunifTanjim/nui.nvim", -- library noice depends on
	"https://github.com/folke/noice.nvim",
})

local noice = require("noice")
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
