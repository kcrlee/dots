local group = "init"

local autocmd = vim.api.nvim_create_autocmd

vim.api.nvim_create_augroup(group, { clear = true })

vim.cmd([[autocmd BufEnter * set formatoptions-=cro]])

autocmd({ "BufReadPre", "BufNewFile", "BufWritePost" }, {
	group = group,
	callback = function()
		require("lint").try_lint()
	end,
})
autocmd("LspAttach", {
	group = group,
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
				group = vim.api.nvim_create_augroup(group, { clear = false }),
				buffer = args.buf,
				callback = function()
					-- disable while I figured out if I want conform.nvim or LSP
					-- vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
				end,
			})
		end
	end,
})

autocmd("FileType", {
	group = group,
	callback = function(ev)
		local filetype = ev.match
		local lang = vim.treesitter.language.get_lang(filetype)
		if lang then
			if vim.treesitter.language.add(lang) then
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				vim.treesitter.start()
			end
		end
	end,
})

autocmd({ "BufReadPre", "BufNewFile", "BufWritePost" }, {
	callback = function()
		require("lint").try_lint()
	end,
	group = group,
})
