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


utils.add_plugin({
	utils.gh("nvim-lua/plenary.nvim"),
	utils.gh("nvim-tree/nvim-web-devicons"),
	utils.gh("stevearc/oil.nvim"),
	utils.gh("mason-org/mason.nvim"),
	utils.gh("nvim-treesitter/nvim-treesitter"),
	utils.gh("NeogitOrg/neogit"),
	utils.gh("stevearc/oil.nvim"),
	utils.gh("ibhagwan/fzf-lua"),
	utils.gh("folke/snacks.nvim"),
	utils.gh("folke/trouble.nvim"),
	utils.gh("folke/lazydev.nvim"),
	utils.gh("saghen/blink.nvim"),
	utils.gh("folke/tokyonight.nvim"),
})

vim.cmd[[colorscheme tokyonight-storm]]


local fzf = require("fzf-lua")
local mason = require("mason").setup({})
local ts = require("nvim-treesitter")



local map = vim.keymap.set
map("n", "<leader>g", require("neogit").open)
map("n", "<F12>", ":UndotreeToggle <Enter>")
map("n", "<leader>vc", ":VimtexCompile <Enter>")
map("n", "<leader>i", ":Inspect <Enter>")
map("n", "<leader>ff", fzf.files)
map("n", "<leader>fg", fzf.live_grep)
map("n", "-", "<CMD>Oil<CR>")

