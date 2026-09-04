return {
	cmd = function(dispatchers, config)
		local cmd = "vscode-eslint-language-server"
		local root = (config or {}).root_dir
		if root then
			local local_cmd = vim.fs.joinpath(root, "node_modules/.bin", cmd)
			if vim.fn.executable(local_cmd) == 1 then
				cmd = local_cmd
			end
		end
		return vim.lsp.rpc.start({ cmd, "--stdio" }, dispatchers)
	end,
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
		"svelte",
		"astro",
	},
	-- Only start in projects that actually configure eslint.
	workspace_required = true,
	root_markers = {
		"eslint.config.js",
		"eslint.config.mjs",
		"eslint.config.cjs",
		"eslint.config.ts",
		"eslint.config.mts",
		"eslint.config.cts",
		".eslintrc",
		".eslintrc.js",
		".eslintrc.cjs",
		".eslintrc.json",
		".eslintrc.yaml",
		".eslintrc.yml",
	},
	settings = {
		validate = "on",
		run = "onType",
		experimental = { useFlatConfig = false },
		codeAction = {
			disableRuleComment = { enable = true, location = "separateLine" },
			showDocumentation = { enable = true },
		},
		codeActionOnSave = { enable = false, mode = "all" },
		format = false, -- conform owns formatting
		nodePath = "",
		problems = { shortenToSingleLine = false },
		quiet = false,
		rulesCustomizations = {},
		workingDirectory = { mode = "auto" },
	},
	before_init = function(_, config)
		-- The server needs to know the workspace folder it should run in.
		if config.root_dir then
			config.settings.workspaceFolder = {
				uri = vim.uri_from_fname(config.root_dir),
				name = vim.fn.fnamemodify(config.root_dir, ":t"),
			}
		end
	end,
	handlers = {
		["eslint/openDoc"] = function(_, result)
			if result then
				vim.ui.open(result.url)
			end
			return {}
		end,
		["eslint/confirmESLintExecution"] = function(_, result)
			if not result then
				return
			end
			return 4 -- approved
		end,
		["eslint/probeFailed"] = function()
			vim.notify("[eslint] ESLint probe failed.", vim.log.levels.WARN)
			return {}
		end,
		["eslint/noLibrary"] = function()
			vim.notify("[eslint] Unable to find ESLint library.", vim.log.levels.WARN)
			return {}
		end,
	},
}
