return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile", "BufWritePost	" },
	opts = {
		linters = {
			sqlfluff = {
				args = {
					"lint",
					"--format=json",
					-- note: users will have to replace the --dialect argument accordingly
					"--dialect=postgres",
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
