local utils = require("utils")

-- vim.cmd([[set mouse=]])
-- Config
vim.o.spelllang = "en_us"
vim.o.undofile = true
vim.o.swapfile = false
vim.o.termguicolors = true
vim.opt.completeopt = { "menuone", "noselect", "popup" }

-- UI
vim.o.relativenumber = true
vim.o.number = true
vim.o.winborder = "rounded"
vim.o.signcolumn = "yes"
vim.o.cursorcolumn = false

-- Splits
vim.o.splitright = true
vim.o.splitbelow = true

-- Text layout
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.smartindent = true

-- Searching
vim.o.ignorecase = true
vim.o.smartcase = true
vim.opt.grepprg = "rg --smartcase --vimgrep"
vim.opt.grepformat = "%f:%l:%c:%m"

--global
vim.g.mapleader = ","

vim.pack.add({
	utils.gh("nvim-lua/plenary.nvim"),
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	utils.gh("nvim-treesitter/nvim-treesitter-context"),
	utils.gh("nvim-tree/nvim-web-devicons"),
	utils.gh("github.com/neovim/nvim-lspconfig"),
	utils.gh("stevearc/oil.nvim"),
	utils.gh("mason-org/mason.nvim"),
	utils.gh("NeogitOrg/neogit"),
	utils.gh("stevearc/oil.nvim"),
	utils.gh("ibhagwan/fzf-lua"),
	utils.gh("folke/snacks.nvim"),
	utils.gh("folke/trouble.nvim"),
	utils.gh("folke/lazydev.nvim"),
	-- utils.gh("saghen/blink.nvim"),
	utils.gh("folke/tokyonight.nvim"),
	utils.gh("stevearc/conform.nvim"),
	utils.gh("mfussenegger/nvim-lint")
})

vim.cmd [[colorscheme tokyonight-storm]]


local fzf = require("fzf-lua")
fzf.setup({ 'fzf-native' })

local mason = require("mason")
mason.setup({})

local oil = require('oil')
oil.setup({})


local neogit = require('neogit')
neogit.setup({})

local lint = require("lint")

local conform = require("conform")
conform.setup({})

local map = vim.keymap.set

map("n", "<leader>g", require("neogit").open)
map("n", "<F12>", ":UndotreeToggle <Enter>")
map("n", "<leader>vc", ":VimtexCompile <Enter>")
map("n", "<leader>i", ":Inspect <Enter>")
map("n", "<leader>ff", fzf.files)
map("n", "<leader>fg", fzf.live_grep)
map("n", "-", ":Oil<CR>")

-- LSP
--
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup("config", { clear = true })
local function setup_lsp()
	vim.lsp.enable({
		"cssls", -- npm i -g vscode-langservers-extracted
		"gopls", -- os package mgr: gopls
		"html",
		"jsonls",
		"lua_ls", -- os package mgr: lua-language-server
		"pyright", -- npm i -g pyright
		"ts_ls", -- npm i -g typescript typescript-language-server
		"html_lsp",
		"tailwindcss"
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

			local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
			local methods = vim.lsp.protocol.Methods

			if client:supports_method(methods.textDocument_completion) then
				vim.lsp.completion.enable(true, client.id, args.buf, {
					autotrigger = true,
					convert = function(item)
						-- Don't preselect any item
						item.preselect = false
						return item
					end
				})
			end

			-- lint
			-- format
			if not client:supports_method('textDocument/willSaveWaitUntil')
				and client:supports_method('textDocument/formatting') then
				vim.api.nvim_create_autocmd('BufWritePre', {
					group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
					buffer = args.buf,
					callback = function()
						vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
					end,
				})
			end
		end,
	})
end


local function setup_ts()
	local ts = require('nvim-treesitter')
	require("nvim-treesitter.configs").setup({
		ensure_installed = {
			"bash", "c", "dockerfile", "fish", "git_config", "git_rebase",
			"gitattributes", "gitcommit", "gitignore", "go", "gomod", "gosum",
			"html", "javascript", "json", "lua", "make", "markdown", "python",
			"sql", "toml", "tsx", "typescript", "yaml", "zig",
		},
		highlight = { enable = true },
		indent = { enable = true },
	})
	autocmd("PackChanged", {
		group = augroup,
		callback = function(args)
			local spec = args.data.spec
			if spec and spec.name == "nvim-treesitter" and args.data.kind == "update" then
				vim.schedule(function()
					ts.update()
				end)
			end
		end,
	})
	autocmd("FileType", {
		group = augroup,
		callback = function(args)
			local filetype = args.match
			local lang = vim.treesitter.language.get_lang(filetype)
			if lang then
				if vim.treesitter.language.add(lang) then
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					vim.treesitter.start()
				end
			end
		end,
	})
end

setup_ts()
setup_lsp()
require("treesitter-context").setup({ max_lines = 3, separator = ">", mode = "topline" })
