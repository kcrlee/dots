local util = require("util")
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
		lspconfig.sourcekit.setup({
			filetypes = { "swift", "c", "cpp", "objective-c", "objc", "objective-cpp" },
			root_dir = lspconfig.util.root_pattern(".git", "Package.swift"),
			capabilities = {
				workspace = {
					didChangeWatchedFIles = { dynamicRegistration = true },
				},
			},
		})

		lspconfig.clangd.setup({
			capabilities = capabilities,
		})

		lspconfig.lua_ls.setup({
			capabilities = capabilities,
		})

		lspconfig.denols.setup({
			root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
		})

		lspconfig.ts_ls.setup({
			root_dir = lspconfig.util.root_pattern("package.json"),
			single_file_support = false,
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

		lspconfig.ts_ls.setup({
			on_attach = function(client)
				client.resolved_capabilities.document_formatting = false
			end,
		})

		lspconfig.astro.setup({})

		lspconfig.sqls.setup({
			capabilities = capabilities,
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
