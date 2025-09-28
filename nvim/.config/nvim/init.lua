local utils = require("utils")

-- Config
vim.o.spelllang = "en_us"
vim.o.undofile = true
vim.o.swapfile = false
vim.o.termguicolors = true
vim.opt.completeopt = { "menuone", "noselect", "popup" }

-- UI
--vim.o.nu = true
vim.o.rnu = true
vim.o.statuscolumn = "%=%{v:lnum} %{v:relnum} %s"
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
	{
		src = "nvim-lua/plenary.nvim",
		name = "plenary"
	},
	{
		src = "https://github.com/adriankarlen/plugin-view.nvim",
		name = 'plugin-view'
	},
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		version = "main",
		name = 'nvim-treesitter'
	},
	{
		src = "nvim-treesitter/nvim-treesitter-context",
		name = "nvim-treesitter-context"
	},

	{
		src = "neovim/nvim-lspconfig",
		name = "nvim-lspconfig"
	},

	{
		src = "nvim-tree/nvim-web-devicons",
		name = "nvim-web-devicons"
	},
	{
		src = "NeogitOrg/neogit",
		name = "neogit"
	},
	{
		src = "mason-org/mason.nvim",
		name = "mason.nvim"
	},
	{
		src = "mbbill/undotree",
		name = "undotree"
	},
	{
		src = "stevearc/oil.nvim",
		name = "oil.nvim"
	},
	{
		src = "ibhagwan/fzf-lua",
		name = "fzf-lua"
	},
	{
		src = "folke/snacks.nvim",
		name = "snack.nvim"
	},
	{
		src = "folke/trouble.nvim",
		name = "trouble.nvim"
	},
	{
		src = "folke/lazydev.nvim",
		name = "lazydev.nvim"
	},
	{
		src = "folke/noice.nvim",
		name = "noice"
	},
	{
		src = "folke/tokyonight.nvim",
	},

	{
		src = "MunifTanjim/nui.nvim",
		name = "nui.nvim"
	},
	{
		src = "rcarriga/nvim-notify",
		name = "nvim-notify"
	},
	{
		src = "https://github.com/saghen/blink.cmp",
		name = "blink.cmp",
		version = vim.version.range('1.*'),
		build = 'cargo build --release',
	},
	{
		src = "https://github.com/rafamadriz/friendly-snippets",
		name = "friendly-snippets"
	}
})

vim.cmd [[colorscheme tokyonight-storm]]


local snacks = require('snacks')
snacks.setup({
	image = { enabled = true },
	bigfile = { enabled = true },
	explorer = { enabled = false },
})

local trouble = require('trouble')
trouble.setup({})


local noice = require("noice")
noice.setup({
	lsp = {
		-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
		},
	},
	-- you can enable a preset for easier configuration
	presets = {
		bottom_search = true,   -- use a classic bottom cmdline for search
		command_palette = true, -- position the cmdline and popupmenu together
		long_message_to_split = true, -- long messages will be sent to a split
		inc_rename = false,     -- enables an input dialog for inc-rename.nvim
		lsp_doc_border = true,  -- add a border to hover docs and signature help
	},
})





local blink = require('blink.cmp')
blink.setup({
	fuzzy = {
		implementation = 'prefer_rust',
		frecency = {
			enabled = true,
		},
		prebuilt_binaries = {
			download = true,
			force_version = "1.*"
		}
	},

	signature = { enabled = true },
	appearance = {
		nerd_font_variant = "mono"
	},
	sources = {
		default = { 'lsp', 'path', 'snippets', 'buffer' },
		providers = {
			buffer = {
				opts = {
					get_bufnrs = function()
						return vim.tbl_filter(function(bufnr)
							return vim.bo[bufnr].buftype == ''
						end, vim.api.nvim_list_bufs())
					end
				}
			}
		}
	},
	completion = {
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 200,
		}
	},
	keymap = {
		preset = "default",
		["<C-space>"] = {},
		["<C-p>"] = {},
		["<Tab>"] = {},
		["<S-Tab>"] = {},
		["<C-y>"] = { "show", "show_documentation", "hide_documentation" },
		["<C-n>"] = { "select_and_accept" },
		["<C-k>"] = { "select_prev", "fallback" },
		["<C-j>"] = { "select_next", "fallback" },
		["<C-b>"] = { "scroll_documentation_down", "fallback" },
		["<C-f>"] = { "scroll_documentation_up", "fallback" },
		["<C-l>"] = { "snippet_forward", "fallback" },
		["<C-h>"] = { "snippet_backward", "fallback" },
		-- ["<C-e>"] = { "hide" },
	},

})

local fzf = require("fzf-lua")
fzf.setup({ 'fzf-native' })

local mason = require("mason")
mason.setup({})

local oil = require('oil')
oil.setup({
	-- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
	-- Set to false if you still want to use netrw.
	default_file_explorer = true,
	-- Id is automatically added at the beginning, and name at the end
	-- See :help oil-columns
	columns = {
		"icon",
		-- "permissions",
		-- "size",
		-- "mtime",
	},
	-- Buffer-local options to use for oil buffers
	buf_options = {
		buflisted = false,
		bufhidden = "hide",
	},
	-- Window-local options to use for oil buffers
	win_options = {
		wrap = false,
		signcolumn = "no",
		cursorcolumn = false,
		foldcolumn = "0",
		spell = false,
		list = false,
		conceallevel = 3,
		concealcursor = "nvic",
	},
	-- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
	delete_to_trash = true,
	-- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
	skip_confirm_for_simple_edits = false,
	-- Selecting a new/moved/renamed file or directory will prompt you to save changes first
	-- (:help prompt_save_on_select_new_entry)
	prompt_save_on_select_new_entry = true,
	-- Oil will automatically delete hidden buffers after this delay
	-- You can set the delay to false to disable cleanup entirely
	-- Note that the cleanup process only starts when none of the oil buffers are currently displayed
	cleanup_delay_ms = 2000,
	lsp_file_methods = {
		-- Time to wait for LSP file operations to complete before skipping
		timeout_ms = 1000,
		-- Set to true to autosave buffers that are updated with LSP willRenameFiles
		-- Set to "unmodified" to only save unmodified buffers
		autosave_changes = false,
	},
	-- Constrain the cursor to the editable parts of the oil buffer
	-- Set to `false` to disable, or "name" to keep it on the file names
	constrain_cursor = "editable",
	-- Set to true to watch the filesystem for changes and reload oil
	experimental_watch_for_changes = false,
	-- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
	-- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
	-- Additionally, if it is a string that matches "actions.<name>",
	-- it will use the mapping at require("oil.actions").<name>
	-- Set to `false` to remove a keymap
	-- See :help oil-actions for a list of all available actions
	keymaps = {
		["g?"] = "actions.show_help",
		["<CR>"] = "actions.select",
		["<C-s>"] = "actions.select_vsplit",
		["<C-h>"] = "actions.select_split",
		["<C-t>"] = "actions.select_tab",
		["<C-p>"] = "actions.preview",
		["<C-c>"] = "actions.close",
		["<C-l>"] = "actions.refresh",
		["-"] = "actions.parent",
		["_"] = "actions.open_cwd",
		["`"] = "actions.cd",
		["~"] = "actions.tcd",
		["gs"] = "actions.change_sort",
		["gx"] = "actions.open_external",
		["g."] = "actions.toggle_hidden",
		["g\\"] = "actions.toggle_trash",
	},
	-- Set to false to disable all of the above keymaps
	use_default_keymaps = true,
	view_options = {
		-- Show files and directories that start with "."
		show_hidden = true,
		-- This function defines what is considered a "hidden" file
		is_hidden_file = function(name, bufnr)
			return vim.startswith(name, ".")
		end,
		-- This function defines what will never be shown, even when `show_hidden` is set
		is_always_hidden = function(name, bufnr)
			return false
		end,
		-- Sort file names in a more intuitive order for humans. Is less performant,
		-- so you may want to set to false if you work with large directories.
		natural_order = true,
		sort = {
			-- sort order can be "asc" or "desc"
			-- see :help oil-columns to see which columns are sortable
			{ "type", "asc" },
			{ "name", "asc" },
		},
	},
	-- Extra arguments to pass to SCP when moving/copying files over SSH
	extra_scp_args = {},
	-- EXPERIMENTAL support for performing file operations with git
	git = {
		-- Return true to automatically git add/mv/rm files
		add = function(path)
			return false
		end,
		mv = function(src_path, dest_path)
			return false
		end,
		rm = function(path)
			return false
		end,
	},
	-- Configuration for the floating window in oil.open_float
	float = {
		-- Padding around the floating window
		padding = 2,
		max_width = 0,
		max_height = 0,
		border = "rounded",
		win_options = {
			winblend = 0,
		},
		-- This is the config that will be passed to nvim_open_win.
		-- Change values here to customize the layout
		override = function(conf)
			return conf
		end,
	},
	-- Configuration for the actions floating preview window
	preview = {
		-- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
		-- min_width and max_width can be a single value or a list of mixed integer/float types.
		-- max_width = {100, 0.8} means "the lesser of 100 columns or 80% of total"
		max_width = 0.9,
		-- min_width = {40, 0.4} means "the greater of 40 columns or 40% of total"
		min_width = { 40, 0.4 },
		-- optionally define an integer/float for the exact width of the preview window
		width = nil,
		-- Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
		-- min_height and max_height can be a single value or a list of mixed integer/float types.
		-- max_height = {80, 0.9} means "the lesser of 80 columns or 90% of total"
		max_height = 0.9,
		-- min_height = {5, 0.1} means "the greater of 5 columns or 10% of total"
		min_height = { 5, 0.1 },
		-- optionally define an integer/float for the exact height of the preview window
		height = nil,
		border = "rounded",
		win_options = {
			winblend = 0,
		},
		-- Whether the preview window is automatically updated when the cursor is moved
		update_on_cursor_moved = true,
	},
	-- Configuration for the floating progress window
	progress = {
		max_width = 0.9,
		min_width = { 40, 0.4 },
		width = nil,
		max_height = { 10, 0.9 },
		min_height = { 5, 0.1 },
		height = nil,
		border = "rounded",
		minimized_border = "none",
		win_options = {
			winblend = 0,
		},
	},
	-- Configuration for the floating SSH window
	ssh = {
		border = "rounded",
	},
	-- Configuration for the floating keymaps help window
	keymaps_help = {
		border = "rounded",
	},
})



local neogit = require('neogit')
neogit.setup({})

-- local lint = require("lint")
-- local conform = require("conform")
-- conform.setup({})

local treesitter_ctx = require("treesitter-context")
treesitter_ctx.setup({
	max_lines = 3,
	separator = "-",
	mode = "topline"
})

local map = vim.keymap.set

map("n", "<leader>g", require("neogit").open)

map("n", "<F12>", ":UndotreeToggle <Enter>")

map("n", "<leader>i", ":Inspect <Enter>")


map("n", "<leader>ff", fzf.files)
map("n", "<leader>fg", fzf.live_grep)

map("n", "-", ":Oil<CR>")

map("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", { silent = true, noremap = true })
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { silent = true, noremap = true })
map(
	"n",
	"<leader>xX",
	"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
	{ silent = true, noremap = true }
)
-- LSP
--
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup("config", { clear = true })
local function setup_lsp()
	vim.lsp.enable({
		"bashls",
		"cssls",
		"eslint",
		"gopls",
		"html",
		"jsonls",
		"lua_ls",
		"shopify_theme_ls",
		"svelte",
		"tailwindcss",
		"rust_analyzer",
		"ts_ls",
		"typos_lsp",
		"html_lsp",
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
	require("nvim-treesitter").setup({
		ensure_installed = {
			"bash",
			"c",
			"dockerfile",
			"fish",
			"git_config",
			"git_rebase",
			"gitattributes",
			"gitcommit",
			"gitignore",
			"go",
			"gomod",
			"gosum",
			"html",
			"javascript",
			"json",
			"lua",
			"liquid",
			"make",
			"markdown",
			"python",
			"sql",
			"toml",
			"tsx",
			"typescript",
			"yaml",
			"zig",
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
