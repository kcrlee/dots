vim.pack.add({
	-- noice (and its nui dependency) must be on the runtimepath before the
	-- statusline components below require it at setup time
	"https://github.com/MunifTanjim/nui.nvim",
	"https://github.com/folke/noice.nvim",
	"https://github.com/nvim-lualine/lualine.nvim",
})

local lualine = require("lualine")
lualine.setup({
	sections = {
		lualine_x = {
			{
				require("noice").api.statusline.mode.get,
				cond = require("noice").api.statusline.mode.has,
				color = { fg = "#ff9e64" },
			},
			{
				function() return require("ledger.lualine").get() end,
				cond = function()
					local ok, ft = pcall(require, "ledger.lualine")
					return ok and ft.has()
				end,
			},
		},
	},

})
