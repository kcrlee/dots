return {
	config = function()
		local autocmd = vim.api.nvim_create_autocmd
		local augroup = vim.api.nvim_create_augroup("config", { clear = true })
		vim.lsp.enable({
			"bashls",
			"cssls",
			"html",
			"jsonls",
			"lua_ls",
			"shopify_theme_ls",
			"svelte",
			"tailwindcss",
			"rust_analyzer",
			"ts_ls",
			"typos_lsp",
			"graphql",
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

		autocmd("LspAttach", {
			group = augroup,
			callback = function(args)
				local bufopts = { noremap = true, silent = true, buffer = args.buf }
				vim.keymap.set("n", "gd", function()
					vim.lsp.buf.definition()
				end, bufopts)
				vim.keymap.set("n", "K", function()
					vim.lsp.buf.hover()
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
				vim.keymap.set("i", "<C-h>", function()
					vim.lsp.buf.signature_help()
				end, bufopts)
				--
				local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
				local methods = vim.lsp.protocol.Methods

				-- if client:supports_method(methods.textDocument_completion) then
				-- 	vim.lsp.completion.enable(true, client.id, args.buf, {
				-- 		autotrigger = true,
				-- 		convert = function(item)
				-- 			-- Don't preselect any item
				-- 			item.preselect = false
				-- 			return item
				-- 		end
				-- 	})
				-- end

				if
					not client:supports_method("textDocument/willSaveWaitUntil")
					and client:supports_method("textDocument/formatting")
				then
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = vim.api.nvim_create_augroup("lsp", { clear = false }),
						buffer = args.buf,
						callback = function()
							--disbale while I figured out if I want conform.nvim or LSP
							-- vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
						end,
					})
				end
			end,
		})
	end,
	defer = true,
	dependencies = {
		{
			defer = true,
			src = "https://github.com/williamboman/mason.nvim",
		},
	},
	src = "https://github.com/neovim/nvim-lspconfig",
}
