local map = vim.keymap.set
local augroup = vim.api.nvim_create_augroup
local LSPGroup = augroup("LSPGroup", {})
local autocmd = vim.api.nvim_create_autocmd
autocmd({ "BufWritePre" }, {
	group = LSPGroup,
	pattern = "*",
	command = [[%s/\s\+$//e]],
})

autocmd("LspAttach", {
	group = LSPGroup,
	callback = function(e)
		local opts = { buffer = e.buf }
		map("n", "gd", function()
			vim.lsp.buf.definition()
		end, opts)
		map("n", "K", function()
			vim.lsp.buf.hover()
		end, opts)
		map("n", "<leader>vws", function()
			vim.lsp.buf.workspace_symbol()
		end, opts)
		map("n", "M", function()
			vim.diagnostic.open_float()
		end, opts)
		map("n", "<leader>vca", function()
			vim.lsp.buf.code_action()
		end, opts)
		map("n", "<leader>vrr", function()
			vim.lsp.buf.references()
		end, opts)
		map("n", "<leader>vrn", function()
			vim.lsp.buf.rename()
		end, opts)
		map("i", "<C-h>", function()
			vim.lsp.buf.signature_help()
		end, opts)
	end,
})

vim.lsp.enable({
	"lua_ls",
	"rust_analyzer",
	"ts_ls",
	"denols",
	"html",
	"tailwindcss"

})
local StopNeovimDaemons = vim.api.nvim_create_augroup("StopNeovimDaemons", {})
vim.api.nvim_create_autocmd("ExitPre", {
	group = StopNeovimDaemons,
	callback = function()
		vim.fn.jobstart(vim.fn.expand("~/.local/bin/utils/stop_nvim_daemons.sh"), { detach = true })
	end,
})



vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp", { clear = true }),
	callback = function(args)
		-- 2
		vim.api.nvim_create_autocmd("BufWritePre", {
			-- 3
			buffer = args.buf,
			callback = function()
				-- 4 + 5
				vim.lsp.buf.format { async = false, id = args.data.client_id }
			end,
		})
	end
})
