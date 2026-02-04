return {
	config = function()
		local fzf = require("fzf-lua")
		fzf.setup({ "telescope" })
	end,
	defer = true,
	src = "https://github.com/ibhagwan/fzf-lua",
}
