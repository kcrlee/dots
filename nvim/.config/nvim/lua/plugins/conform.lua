vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

local conform = require("conform")

-- In biome projects run biome + organize-imports; elsewhere keep the
-- first-available-formatter behavior (stop_after_first can't express both).
local function biome_project_chain(fallback)
	return function(bufnr)
		local dirname = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
		local has_biome_config = vim.fs.find({ "biome.json", "biome.jsonc" }, {
			upward = true,
			path = dirname,
			type = "file",
		})[1]
		if has_biome_config then
			return { "biome", "biome-organize-imports" }
		end
		return fallback
	end
end

conform.setup({
	quiet = true,
	formatters = {
		prettier = {
			args = function(_, ctx)
				local prettier_roots = {
					".prettierrc",
					".prettierrc.json",
					"prettier.config.js",
					".prettierrc.mjs",
					"prettier.config.ts",
					"prettier.config.mts",
				}
				local args = { "--stdin-filepath", "$FILENAME" }
				-- Add parser for SVG files
				local bufname = vim.api.nvim_buf_get_name(ctx.buf)
				if bufname:match("%.svg$") then
					vim.list_extend(args, { "--parser", "html" })
				end
				local config_path = vim.fn.stdpath("config")

				local localPrettierConfig = vim.fs.find(prettier_roots, {
					upward = true,
					path = ctx.dirname,
					type = "file",
				})[1]
				local globalPrettierConfig = vim.fs.find(prettier_roots, {
					path = type(config_path) == "string" and config_path or config_path[1],
					type = "file",
				})[1]
				local disableGlobalPrettierConfig = os.getenv("DISABLE_GLOBAL_PRETTIER_CONFIG")

				-- Project config takes precedence over global config
				if localPrettierConfig then
					vim.list_extend(args, { "--config", localPrettierConfig })
				elseif globalPrettierConfig and not disableGlobalPrettierConfig then
					vim.list_extend(args, { "--config", globalPrettierConfig })
				end

				local hasTailwindPrettierPlugin = vim.fs.find("node_modules/prettier-plugin-tailwindcss", {
					upward = true,
					path = ctx.dirname,
					type = "directory",
				})[1]

				if hasTailwindPrettierPlugin then
					vim.list_extend(args, { "--plugin", "prettier-plugin-tailwindcss" })
				end

				return args
			end,
		},
	},
	formatters_by_ft = {
		swift = { "swiftformat" },
		astro = { "prettier" },
		sql = { "sqlfmt" },
		lua = { "stylua" },
		typescript = biome_project_chain({ "prettier", "biome", stop_after_first = true }),
		typescriptreact = biome_project_chain({ "prettier", "biome", stop_after_first = true }),
		javascript = biome_project_chain({ "prettier", "biome", stop_after_first = true }),
		javascriptreact = biome_project_chain({ "biome" }),
		json = {
			"jq",
			"biome",
			stop_after_first = true,
		},
		liquid = {
			"prettier",
			stop_after_first = true,
		},
		python = { "black" },
		html = { "prettier" },
		svg = { "prettier" },
		svelte = { "biome", "biome-organize-imports" },
		css = { "biome" },
		scss = { "prettier" },
		markdown = { "prettier" },
		yaml = { "prettier" },
		graphql = {
			"prettier",
			"biome",
			stop_after_first = true,
		},
		vue = { "prettier", stop_after_first = true },
		sh = { "shfmt" },
		bash = { "shfmt" },
		zsh = { "shfmt" },
		haskell = { "fourmolu" },
	},
	default_format_opts = {
		lsp_format = "fallback",
	},
	format_on_save = function(bufnr)
		local bufname = vim.api.nvim_buf_get_name(bufnr)
		if bufname:match("/node_modules/") then
			return
		end
		return { timeout_ms = 1000, lsp_format = "fallback" }
	end,
})
