vim.cmd([[set mouse=]])
vim.o.winborder = "rounded"
vim.o.wrap = false
vim.o.relativenumber = true
vim.o.number = true
vim.o.swapfile = false
vim.o.tabstop = 4
vim.o.smartindent = true
vim.o.signcolumn = "yes"
vim.o.cursorcolumn = false
vim.o.ignorecase = true
vim.o.undofile = true
--globals
vim.g.mapleader = ","



vim.pack.add({
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/RRethy/base16-nvim" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/ibhagwan/fzf-lua" },
	{ src = "https://github.com/NeogitOrg/neogit" }
})

-- Colors

vim.cmd('colorscheme base16-tomorrow-night')

-- Oil

require('oil').setup({})


-- Treesitter
require "nvim-treesitter.configs".setup({
	ensure_installed = { highlight = { enable = true, } }
})

-- Mason
local mason = require('mason')
mason.setup({})

local fzf = require('fzf-lua')
local map = vim.keymap.set

map('n', '<leader>g', require('neogit').open)
map("n", "<F12>", ":UndotreeToggle <Enter>")
map("n", "<leader>vc", ":VimtexCompile <Enter>")
map("n", "<leader>i", ":Inspect <Enter>")
map('n', '<leader>ff', fzf.files)
map('n', '<leader>fg', fzf.live_grep)
map('n', '-', ":Oil<CR>")

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

local StopNeovimDaemons = vim.api.nvim_create_augroup("StopNeovimDaemons", {})
vim.api.nvim_create_autocmd("ExitPre", {
	group = StopNeovimDaemons,
	callback = function()
		vim.fn.jobstart(vim.fn.expand("~/.local/bin/utils/stop_nvim_daemons.sh"), { detach = true })
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
