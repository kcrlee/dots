return {
	"neovim/nvim-lspconfig",
	dependencies = {
		-- Install Servers with Mason
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		-- Autocompletion
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"uga-rosa/cmp-dictionary",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"j-hui/fidget.nvim",
		"rafamadriz/friendly-snippets",
	},
	config = function()
		local cmp = require("cmp")
		local cmp_lsp = require("cmp_nvim_lsp")
		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			cmp_lsp.default_capabilities()
		)

		local lspconfig = require("lspconfig")
		lspconfig.hls.setup({
			capabilities = capabilities,
		})
		lspconfig.elixirls.setup({
			capabilities = capabilities,
			cmd = { "/home/kyle/.local/share/nvim/mason/packages/elixir-ls/language_server.sh" },
			filetypes = { "elixir", "eelixir", "heex", "surface" },
		})

		lspconfig.sourcekit.setup({
			cmd = { "/usr/bin/sourcekit-lsp" },
			filetypes = { "swift", "c", "cpp", "objective-c", "objc", "objective-cpp" },
			root_dir = lspconfig.util.root_pattern({ ".git", "Package.swift" }),
			capabilities = {
				workspace = {
					didChangeWatchedFIles = { dynamicRegistration = true },
				},
			},
		})

		lspconfig.gopls.setup({
			capabilities = capabilities,
			settings = {},
		})

		lspconfig.eslint.setup({
			capabilities = capabilities,
			root_dir = lspconfig.util.root_pattern({
				"package.json",
				"eslint.config.js",
				"eslint.config.ts",
				".eslintrc.js",
			}),
			root_markers = { "eslint.config.js", "eslint.config.ts", ".eslintrc.js", "package.json" },
			workspace_required = true,
		})

		lspconfig.denols.setup({
			capabilities = capabilities,
			root_markers = { "deno.json, deno.jsonc" },
			root_dir = lspconfig.util.root_pattern({ "deno.json", "deno.jsoc" }),
			workspace_required = true,
		})

		lspconfig.clangd.setup({
			capabilities = capabilities,
		})

		lspconfig.lua_ls.setup({
			capabilities = capabilities,
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim", "it", "describe", "before_each", "after_each" },
					},
				},
			},
		})

		lspconfig.shopify_theme_ls.setup({
			capabilities = capabilities,
			root_dir = lspconfig.util.root_pattern({
				".shopifyignore",
				".theme-check.yml",
				".theme-check.yaml",
				"shopify.theme.toml",
			}),
		})

		lspconfig.tailwindcss.setup({
			capabilities = capabilities,
			root_dir = lspconfig.util.root_pattern({ ".git", "package.json" }),
			root_markers = { ".git", "package.json" },
			workspace_required = true,
			filetypes = {
				"aspnetcorerazor",
				"astro",
				"astro-markdown",
				"blade",
				"clojure",
				"edge",
				"eelixir",
				"elixir",
				"ejs",
				"erb",
				"eruby",
				"gohtml",
				"gohtmltmpl",
				"haml",
				"handlebars",
				"html",
				"html-eex",
				"heex",
				"jade",
				"leaf",
				"liquid",
				"css",
				"postcss",
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
				"vue",
				"svelte",
				"templ",
			},
		})

		lspconfig.ts_ls.setup({
			capabilities = capabilities,
			root_markers = { "package.json" },
			workspace_required = true,
			single_file_support = false,
		})

		lspconfig.jsonls.setup({
			capabilities = capabilities,
			single_file_support = true,
		})

		lspconfig.rust_analyzer.setup({
			capabilities = capabilities,
		})

		lspconfig.pyright.setup({
			capabilities = capabilities,
			settings = {
				python = {
					analysis = {
						autoSearchPaths = true,
						diagnosticMode = "workspace",
					},
				},
			},
		})

		lspconfig.svelte.setup({
			capabilities = capabilities,
			cmd = { "svelteserver", "--stdio" },
			filetypes = { "svelte" },
			root_dir = lspconfig.util.root_pattern("package.json", "svelete.config.js", "svelete.config.ts"),
		})

		lspconfig.astro.setup({})

		lspconfig.sqls.setup({
			capabilities = capabilities,
		})

		lspconfig.bashls.setup({
			capabilities = capabilities,
		})

		lspconfig.rust_analyzer.setup({
			capabilities = capabilities,
		})

		lspconfig.typos_lsp.setup({
			-- Logging level of the language server. Logs appear in :LspLog. Defaults to error.
			cmd_env = { RUST_LOG = "error" },
			init_options = {
				-- Custom config. Used together with a config file found in the workspace or its parents,
				-- taking precedence for settings declared in both.
				-- Equivalent to the typos `--config` cli argument.
				config = "~/code/typos-lsp/crates/typos-lsp/tests/typos.toml",
				-- How typos are rendered in the editor, can be one of an Error, Warning, Info or Hint.
				-- Defaults to error.
				diagnosticSeverity = "Warning",
			},
		})

		require("fidget").setup({})
		require("mason").setup()
		local cmp_select = { behavior = cmp.SelectBehavior.Select }

		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
				end,
			},
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
				["<CR>"] = cmp.mapping.confirm({ select = true }),
				["<C-Space>"] = cmp.mapping.complete(),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" }, -- For luasnip users.
			}, {
				{ name = "buffer" },
			}),
		})

		vim.diagnostic.config({
			virtual_text = false,
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.WARN] = "",
					[vim.diagnostic.severity.INFO] = "",
					[vim.diagnostic.severity.HINT] = "",
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
	end,
}
