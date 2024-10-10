return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile", "BufWritePost	" },
	config = function()
		local lint = require("lint")
		lint.linters_by_ft = {
			lua = { "luacheck" },
			bash = { "shellcheck" },
			-- javascript = { "eslint_d" },
			-- typescript = { "eslint_d" },
			-- typescriptreact = { "eslint_d" },
			-- javascriptreact = { "eslint_d" },
		}
	end,
}
