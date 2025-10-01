return {
	config = function()
		local notify = require("notify")
		notify.setup({
			timeout = 1000,
			render = "compact",
			stages = "fade",
			top_down = false,
			background_colour = "#000000",
		})
	end,
	defer = true,
	src = "https://github.com/rcarriga/nvim-notify",
}
