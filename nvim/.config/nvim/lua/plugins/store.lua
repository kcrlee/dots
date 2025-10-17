return {
	config = function()
		local store = require("store")
		store.setup({})
	end,
	defer = true,
	src = "https://github.com/alex-popov-tech/store.nvim",
}
