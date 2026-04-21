--global
vim.g.mapleader = ","
vim.o.spelllang = "en_us"
vim.o.termguicolors = true
vim.opt.completeopt = { "fuzzy", "menuone", "noselect", "popup" }
vim.opt.mouse = ""

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

-- File handling
vim.o.writebackup = false
vim.o.backup = false
vim.o.swapfile = false
vim.o.autoread = true
vim.o.autoread = true
vim.o.autowrite = true

-- Text layout
vim.o.textwidth = 120
vim.o.wrap = true
vim.opt.linebreak = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.smartindent = true

-- Searching
vim.o.ignorecase = true
vim.o.smartcase = true
vim.opt.grepprg = "rg --smartcase --vimgrep"
vim.opt.grepformat = "%f:%l:%c:%m"

vim.o.undofile = true
vim.o.undolevels = 1000
vim.o.undodir = vim.fn.expand("~/.vim/undodir")
-- Create undo directory if it doesn't exist
local undodir = vim.fn.expand("~/.vim/undodir")
if vim.fn.isdirectory(undodir) == 0 then
	vim.fn.mkdir(undodir, "p")
end

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
