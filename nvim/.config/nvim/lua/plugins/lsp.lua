vim.pack.add({
	"https://github.com/williamboman/mason.nvim",
	"https://github.com/williamboman/mason-lspconfig.nvim",
	"https://github.com/neovim/nvim-lspconfig",
})

require("mason").setup({
	registries = { "github:crashdummyy/mason-registry", "github:mason-org/mason-registry" },
})
require("mason-lspconfig").setup()

-- blink.lua loads before this file (plugins load alphabetically)
vim.lsp.config("*", {
	capabilities = require("blink.cmp").get_lsp_capabilities(),
})

vim.lsp.enable({
	"bashls",
	"copilot",
	"expert",
	"hls",
	"html",
	"jsonls",
	"lua_ls",
	"svelte",
	"sourcekit",
	"shopify_theme_ls",
	"tailwindcss",
	"tsc",
	"tombi",
	"kulala_ls",
	"rust_analyzer",
	"graphql",
	"vue_ls",
})

-- Deltas for servers nvim-lspconfig ships. These must be vim.lsp.config()
-- calls, not lsp/*.lua files: plugin lsp/ files win the runtimepath merge,
-- while config() calls take precedence over all runtime files.
vim.lsp.config("html", {
	cmd = { "vscode-html-language-server", "--stdio" },
	filetypes = { "html", "htmldjango" },
})

vim.lsp.config("hls", {
	filetypes = { "haskell", "lhaskell", "cabal" },
	settings = {
		haskell = { formattingProvider = "fourmolu" },
	},
})

vim.lsp.config("graphql", {
	filetypes = { "typescript", "javascript", "graphql", "typescriptreact", "javascriptreact" },
	root_dir = function(bufnr, on_dir)
		local fname = vim.api.nvim_buf_get_name(bufnr)
		local util = require("lspconfig.util")
		on_dir(util.root_pattern(".graphqlrc*", ".graphql.config.*", "graphql.config.*", "package.json")(fname))
	end,
})

vim.lsp.config("sourcekit", {
	cmd = { "xcrun", "sourcekit-lsp" },
})

vim.lsp.config("tsc", {
	-- Only keys the TypeScript 7 native server reads (see its js/ts,
	-- typescript, javascript config sections). tsserver-era keys such as
	-- maxTsServerMemory, updateImportsOnFileMove, and completeFunctionCalls
	-- are ignored by the Go implementation.
	settings = {
		typescript = {
			preferences = {
				importModuleSpecifier = "shortest",
				autoImportFileExcludePatterns = {
					"dist/**",
					"**/.tanstack/**",
					"**/generated/**",
					"**/packages/gql/dist/**",
				},
			},
			suggest = {
				autoImports = true,
				includeCompletionsForImportStatements = true,
			},
		},
		javascript = {
			preferences = { importModuleSpecifier = "shortest" },
			suggest = {
				autoImports = true,
				includeCompletionsForImportStatements = true,
			},
		},
	},
})

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			telemetry = { enable = false },
			diagnostics = { globals = { "vim", "require" } },
			workspace = { checkThirdParty = false },
		},
	},
})

vim.lsp.document_color.enable(false)

vim.diagnostic.config({
	virtual_text = false,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "",
		},
	},
	update_in_insert = false,
	underline = true,
	severity_sort = true,
	float = {
		focusable = true,
		style = "minimal",
		border = "rounded",
		source = true,
		header = "",
		prefix = "",
	},
})

-- Buffer-local keymaps and per-client setup, attached when a server starts.
local group = vim.api.nvim_create_augroup("lsp", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
	group = group,
	callback = function(args)
		local bufopts = { noremap = true, silent = true, buffer = args.buf }
		vim.keymap.set("n", "gd", function()
			vim.lsp.buf.definition()
		end, bufopts)
		vim.keymap.set("n", "<leader>vws", function()
			vim.lsp.buf.workspace_symbol()
		end, bufopts)
		vim.keymap.set("n", "M", function()
			vim.diagnostic.open_float()
		end, bufopts)
		vim.keymap.set("n", "<leader>vca", function()
			vim.lsp.buf.code_action()
		end, bufopts)
		vim.keymap.set("n", "<leader>vrr", function()
			vim.lsp.buf.references()
		end, bufopts)
		vim.keymap.set("n", "<leader>vrn", function()
			vim.lsp.buf.rename()
		end, bufopts)

		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

		if client:supports_method("textDocument/hover") then
			vim.keymap.set("n", "K", function()
				vim.lsp.buf.hover({
					border = "rounded",
					max_width = 80,
					max_height = 20,
				})
			end, { buffer = args.buf, desc = "LSP hover" })
		end

		-- Copilot ghost-text completions. Accepted via <Tab> in blink.lua.
		if client:supports_method("textDocument/inlineCompletion") then
			vim.lsp.inline_completion.enable(true, { bufnr = args.buf })
			vim.keymap.set("i", "<C-g>", vim.lsp.inline_completion.select, {
				buffer = args.buf,
				desc = "LSP: cycle inline completion",
			})
		end

		if
			not client:supports_method("textDocument/willSaveWaitUntil")
			and client:supports_method("textDocument/formatting")
		then
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = group,
				buffer = args.buf,
				callback = function()
					-- if we wanted LSP formatting
					-- vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
				end,
			})
		end
	end,
})
