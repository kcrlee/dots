return {
	config = function()
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
	end,
	defer = true,
	src = "https://github.com/nvim-lualine/lualine.nvim",
}
