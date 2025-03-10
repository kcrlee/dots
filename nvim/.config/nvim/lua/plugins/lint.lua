return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile", "BufWritePost	" },
	opts = {
		linters = {
			sqlfluff = {
				args = {
					"lint",
					"--format=json",
				},
			},
		},
	},
	config = function()
		local lint = require("lint")
		lint.linters_by_ft = {
			bash = { "shellcheck" },
			glsl = { "glslc" },
			sql = { "sqlfluff" },
			psql = { "sqlfluff" },
		}
	end,
}
