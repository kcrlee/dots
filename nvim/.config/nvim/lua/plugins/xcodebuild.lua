return {
	config = function()
		local xcodebuild = require("xcodebuild")
		xcodebuild.setup({})
	end,
	defer = true,
	src = "https://github.com/wojciech-kulik/xcodebuild.nvim",
}
