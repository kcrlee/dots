return {
	config = function()
		local lint = require("lint")
		lint.linters_by_ft = {
			swift = { "swiftlint" },
		}
	end,
	defer = true,
	src = "https://github.com/mfussenegger/nvim-lint",
}
