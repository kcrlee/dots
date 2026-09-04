--global
vim.g.mapleader = ","
vim.g.loaded_nvim_dir_plugin = 1
vim.o.spelllang = "en_us"
vim.o.termguicolors = true
-- popup: show completion item docs in a floating window next to the menu.
vim.opt.completeopt = { "menuone", "noselect", "fuzzy", "popup" }
vim.o.pumheight = 12
-- 0.12: pop the menu while typing using 'complete' sources; "o" is the LSP
-- omnifunc, then current buffer, other windows, loaded buffers.
if vim.fn.exists("+autocomplete") == 1 then
	vim.o.autocomplete = true
	vim.o.complete = "o,.,w,b"
end
-- Command-line completion: popup menu, fuzzy, nothing preselected so <CR>
-- runs what was typed. See the CmdlineChanged autocmd for auto-trigger.
vim.o.wildmenu = true
vim.opt.wildoptions = { "pum", "fuzzy" }
-- "noselect" arrived with wildtrigger(); older builds reject it.
if vim.fn.exists("*wildtrigger") == 1 then
	vim.o.wildmode = "noselect:lastused,full"
else
	vim.o.wildmode = "longest:full,full"
end
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
vim.o.autowrite = true

-- Text layout
vim.o.textwidth = 120
vim.o.wrap = true
vim.o.linebreak = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.smartindent = true

-- Searching
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.grepprg = "rg --smartcase --vimgrep"
vim.o.grepformat = "%f:%l:%c:%m"

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
		svg = "html",
	},
	filename = {
		["tsconfig.json"] = "jsonc",
		[".yamlfmt"] = "yaml",
	},
	pattern = {
		["[jt]sconfig.*.json"] = "jsonc",
	},
})
