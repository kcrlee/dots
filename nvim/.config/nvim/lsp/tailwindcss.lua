--- True when the nearest `file` above `fname` contains `pattern`.
local function nearest_file_has(fname, file, pattern)
	local path = vim.fs.find(file, { path = fname, upward = true })[1]
	if not path then
		return false
	end
	local f = io.open(path)
	if not f then
		return false
	end
	local content = f:read("*a")
	f:close()
	return content:find(pattern, 1, true) ~= nil
end

return {
	cmd = function(dispatchers, config)
		local cmd = "tailwindcss-language-server"
		local root = (config or {}).root_dir
		if root then
			local local_cmd = vim.fs.joinpath(root, "node_modules/.bin", cmd)
			if vim.fn.executable(local_cmd) == 1 then
				cmd = local_cmd
			end
		end
		return vim.lsp.rpc.start({ cmd, "--stdio" }, dispatchers)
	end,
	-- Trimmed to filetypes this config actually opens; upstream lists ~50.
	filetypes = {
		"astro",
		"html",
		"htmldjango",
		"heex",
		"eelixir",
		"elixir",
		"liquid",
		"markdown",
		"css",
		"scss",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
		"svelte",
	},
	capabilities = {
		workspace = { didChangeWatchedFiles = { dynamicRegistration = true } },
	},
	settings = {
		tailwindCSS = {
			validate = true,
			lint = {
				cssConflict = "warning",
				invalidApply = "error",
				invalidScreen = "error",
				invalidVariant = "error",
				invalidConfigPath = "error",
				invalidTailwindDirective = "error",
				recommendedVariantOrder = "warning",
			},
			classAttributes = { "class", "className", "class:list", "classList", "ngClass" },
			includeLanguages = {
				eelixir = "html-eex",
				elixir = "phoenix-heex",
				heex = "phoenix-heex",
			},
		},
	},
	before_init = function(_, config)
		config.settings = vim.tbl_deep_extend("keep", config.settings, {
			editor = { tabSize = vim.lsp.util.get_effective_tabstop() },
		})
	end,
	-- Only start inside a project that actually uses Tailwind.
	workspace_required = true,
	root_dir = function(bufnr, on_dir)
		local fname = vim.api.nvim_buf_get_name(bufnr)
		local root_files = {
			"tailwind.config.js",
			"tailwind.config.cjs",
			"tailwind.config.mjs",
			"tailwind.config.ts",
			"postcss.config.js",
			"postcss.config.cjs",
			"postcss.config.mjs",
			"postcss.config.ts",
			-- Tailwind v4 needs no config file; fall back to the repo root.
			".git",
		}
		-- Flat list: nearest of any marker wins, matching upstream.
		if nearest_file_has(fname, "package.json", '"tailwindcss"') then
			table.insert(root_files, "package.json")
		end
		for _, lock in ipairs({ "mix.lock", "Gemfile.lock" }) do
			if nearest_file_has(fname, lock, "tailwind") then
				table.insert(root_files, lock)
			end
		end
		on_dir(vim.fs.root(bufnr, root_files))
	end,
}
