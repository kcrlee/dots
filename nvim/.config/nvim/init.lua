local utils = require("utils")
local vim = vim

vim.cmd([[set mouse=]])
-- Config
vim.o.spelllang = "en_us"
vim.o.undofile = true
vim.o.swapfile = false
vim.o.termguicolors = true

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
	utils.gh("nvim-treesitter/nvim-treesitter-context"),
	utils.gh("github.com/neovim/nvim-lspconfig"),
	utils.gh("nvim-tree/nvim-web-devicons"),
	utils.gh("stevearc/oil.nvim"),
	utils.gh("mason-org/mason.nvim"),
	utils.gh("NeogitOrg/neogit"),
	utils.gh("stevearc/oil.nvim"),
	utils.gh("ibhagwan/fzf-lua"),
	utils.gh("folke/snacks.nvim"),
	utils.gh("folke/trouble.nvim"),
	utils.gh("folke/lazydev.nvim"),
	utils.gh("saghen/blink.nvim"),
	utils.gh("folke/tokyonight.nvim"),
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
})

vim.cmd[[colorscheme tokyonight-storm]]


local fzf = require("fzf-lua")
fzf.setup({'fzf-native'})

local mason = require("mason")
mason.setup({})

local oil = require('oil')
oil.setup({})


local neogit = require('neogit')
neogit.setup({})

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
		callback = function(ev)
			local bufopts = { noremap = true, silent = true, buffer = ev.buf }
			map("n", "gd", vim.lsp.buf.definition, bufopts)
			map("n", "K", vim.lsp.hover, bufopts)
        	map("n", "M", vim.diagnostic.open_float, bufopts)

			local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
			local methods = vim.lsp.protocol.Methods
			if client:supports_method(methods.textDocument_completion) then
				vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
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
	-- Get the module reference
	
	-- Fix: use augroup instead of undefined 'augroup'
	autocmd("PackChanged", {
		group = augroup, -- was: augroup (undefined)
		callback = function(ev)
			local spec = ev.data.spec
			if spec and spec.name == "nvim-treesitter" and ev.data.kind == "update" then
				vim.schedule(function()
					ts.update()
				end)
			end
		end,
	})
	
	autocmd("FileType", {
		group = augroup, -- was: augroup (undefined)
		callback = function(ev)
			local filetype = ev.match
			local lang = vim.treesitter.language.get_lang(filetype)
			if vim.treesitter.language.add(lang) then
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				vim.treesitter.start()
			end
		end,
	})
end

setup_ts()
setup_lsp()
