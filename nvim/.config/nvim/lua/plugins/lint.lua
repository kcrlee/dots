return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile", "BufWritePost	" },
	config = function()
		local lint = require("lint")
		lint.linters_by_ft = {
			lua = { "luacheck" },
			bash = { "shellcheck" },
		}
	end,
}
