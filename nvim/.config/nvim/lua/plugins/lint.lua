return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require('lint')
		lint.linters_by_ft = {
			-- javascript = { "eslint_d" },
			-- typescript = { "eslint_d" },
			-- javascriptreact = { "eslint_d" },
			-- typescriptreact = { "eslint_d" },
			lua = { "luacheck" },
			bash = { "shellcheck" }
		}
		local eslint = lint.linters.eslint_d
		eslint.args = {
			"--no-warn-ignored", -- <-- this is the key argument
			"--format",
			"json",
			"--stdin",
			"--stdin-filename",
			function()
				return vim.api.nvim_buf_get_name(0)
			end,
		}
	end
}
