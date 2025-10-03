return {
	config = function()
		local markview = require("markview")
		local presets = require("markview.presets")

		markview.setup({
			markdown = {
				headings = presets.headings.slanted,
			},
			preview = {
				icon_provider = "devicons", -- "mini" or "devicons"
			},
		})
	end,
	defer = true,
	src = "https://github.com/OXY2DEV/markview.nvim",
}
