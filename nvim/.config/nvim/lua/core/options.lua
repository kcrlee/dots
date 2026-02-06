--global
vim.g.mapleader = ","
vim.o.spelllang = "en_us"
vim.o.undofile = true
vim.o.swapfile = false
vim.o.termguicolors = true
vim.opt.completeopt = { "fuzzy", "menuone", "noselect", "popup" }

-- UI
vim.o.rnu = true
vim.o.statuscolumn = "%=%{v:lnum} %{v:relnum} %s"
vim.o.winborder = "rounded"
vim.o.signcolumn = "yes"
vim.o.cursorcolumn = false
vim.o.scrolloff = 8 -- Ensures 8 lines above and below of the cursor

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

-- Filetype detection
vim.filetype.add({
	extension = {
		env = "sh",
		svg = "html",
	},
	filename = {
		[".env.*"] = "sh",
	},
	pattern = {
		["[jt]sconfig.*.json"] = "jsonc",
		["%.env%.[%w_.-]+"] = "sh",
	},
})
