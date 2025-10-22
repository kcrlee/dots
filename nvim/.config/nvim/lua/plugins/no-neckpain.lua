return {
	config = function()
		local noneckpain = require("no-neck-pain")
		noneckpain.setup({
			buffers = {
				width = 80,
				scratchPad = {
					-- set to `false` to
					-- disable auto-saving
					enabled = false,
					-- set to `nil` to default
					-- to current working directory
					location = nil,
				},
			},
		})
	end,
	defer = true,
	src = "https://github.com/shortcuts/no-neck-pain.nvim",
}
