return {
	config = function()
		local neogit = require("neogit")
		neogit.setup({})
	end,
	defer = true,
	src = "https://github.com/NeogitOrg/neogit",
}
