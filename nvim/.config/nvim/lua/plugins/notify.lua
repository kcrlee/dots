return {
	"rcarriga/nvim-notify",
	config = function()
		require("notify").setup({
			timeout = 1000,
			render = "compact",
			stages = "fade",
			top_down = false,
			background_colour = "#000000",
		})
	end,
}
