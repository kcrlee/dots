return {
	defer = true,
	src = "https://github.com/wojciech-kulik/xcodebuild.nvim",
	config = function()
		require("xcodebuild").setup({
			-- put some options here or leave it empty to use default settings
		})
	end,
}
