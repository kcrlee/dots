-- General Config
vim.o.spelllang = "en_us"
vim.o.undofile = true
vim.o.swapfile = false
vim.o.termguicolors = true
vim.opt.completeopt = { "menuone", "noselect", "popup" }

-- UI
vim.o.rnu = true
vim.o.statuscolumn = "%=%{v:lnum} %{v:relnum} %s"
vim.o.winborder = "rounded"
vim.o.signcolumn = "yes"
vim.o.cursorcolumn = false
vim.o.scrolloff = 8 -- Ensures 8 lines above and below start/end of the file

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
		src = "https://github.com/nvim-lua/plenary.nvim",
		name = "plenary"
	},
	{
		src = "https://github.com/adriankarlen/plugin-view.nvim",
		name = 'plugin-view'
	},
	{
		src = "https://github.com/mezdelex/unpack",
		name = "unpack"
	},
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		version = "main",
		name = 'nvim-treesitter'
	},
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter-context",
		name = "nvim-treesitter-context"
	},
	{
		src = "https://github.com/neovim/nvim-lspconfig",
		name = "nvim-lspconfig"
	},
	{
		src = "https://github.com/nvim-tree/nvim-web-devicons",
		name = "nvim-web-devicons"
	},
	{
		src = "https://github.com/NeogitOrg/neogit",
		name = "neogit"
	},
	{
		src = "https://github.com/mason-org/mason.nvim",
		name = "mason.nvim"
	},
	{
		src = "https://github.com/mbbill/undotree",
		name = "undotree"
	},
	{
		src = "https://github.com/stevearc/oil.nvim",
		name = "oil.nvim"
	},
	{
		src = "https://github.com/ibhagwan/fzf-lua",
		name = "fzf-lua"
	},
	{
		src = "https://github.com/folke/snacks.nvim",
		name = "snack.nvim"
	},
	{
		src = "https://github.com/folke/trouble.nvim",
		name = "trouble.nvim"
	},
	{
		src = "https://github.com/folke/lazydev.nvim",
		name = "lazydev.nvim"
	},
	{
		src = "https://github.com/folke/noice.nvim",
		name = "noice"
	},
	{
		src = "https://github.com/kcrlee/tomorrow-min",
		name = "tomorrow-min"
	},
	{
		src = "https://github.com/rktjmp/lush.nvim",
		name = "lush"
	},

	{
		src = "https://github.com/MunifTanjim/nui.nvim",
		name = "nui.nvim"
	},
	{
		src = "https://github.com/rcarriga/nvim-notify",
		name = "nvim-notify"
	},

	{
		src = "https://github.com/nvim-mini/mini.nvim",
		version = vim.version.range("*")
	},

	{
		src = "https://github.com/saghen/blink.cmp",
		name = "blink.cmp",
		version = vim.version.range('*'),
		build = 'cargo build --release',
	},
	{
		src = "https://github.com/Kaiser-Yang/blink-cmp-dictionary",
		name = "blink-cmp-dictionary"
	},
	{
		src = "https://github.com/L3MON4D3/LuaSnip",
		name = "luasnip"
	},
	{
		src = "https://github.com/rafamadriz/friendly-snippets",
		name = "friendly-snippets"
	}
})

vim.cmd [[colorscheme tomorrow-min]]


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
	-- -- you can enable a preset for easier configuration
	presets = {
		bottom_search = true,   -- use a classic bottom cmdline for search
		command_palette = true, -- position the cmdline and popupmenu together
		long_message_to_split = true, -- long messages will be sent to a split
		inc_rename = false,     -- enables an input dialog for inc-rename.nvim
		lsp_doc_border = true,  -- add a border to hover docs and signature help
	},
})


local notify = require('notify')
notify.setup({
	timeout = 1000,
	render = "compact",
	stages = "fade",
	top_down = false,
	background_colour = "#000000",
})

local plugin_view = require('plugin-view')
plugin_view.setup()

local unpack = require('unpack')
unpack.setup()
local unpack_path = vim.fn.stdpath("data") .. "/site/pack/managers/start/unpack"

if not vim.uv.fs_stat(unpack_path) then
	vim.fn.system({
		'git',
		'clone',
		"--filter=blob:none",
		'https://github.com/mezdelex/unpack',
		unpack_path
	})
end


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
	signature = {
		enabled = true,
		window = { border = "single" }
	},
	appearance = {
		nerd_font_variant = "mono"
	},
	sources = {
		default = { 'lsp', 'path', 'snippets', 'buffer' },
		providers = {
			dictionary = {
				module = "blink-cmp-dictionary",
				name = "Dict",
				score_offset = 20,
				enabled = true,
				max_items = 8,
				min_keyword_length = 3,
				opts = {
					dictionary_directories = { vim.fn.expand("~/.config/nvim/dictionaries") },
				}


			}

		}
	},
	completion = {
		accept = {
			auto_brackets = {
				enabled = false,
			}
		},
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 200,
		},
		menu = {
			auto_show = true,
			draw = {
				padding = { 0, 1 }, -- padding only on right side
				components = {
					kind_icon = {
						text = function(ctx) return ' ' .. ctx.kind_icon .. ctx.icon_gap .. ' ' end
					}
				}
			}
		}
	},
	keymap = {
		preset = "default",
		["<C-space>"] = {},
		["<C-p>"] = {},
		["<Tab>"] = {},
		["<S-Tab>"] = {},
		["<K>"] = { "show", "show_documentation", "hide_documentation", "fallback" },
		["<CR>"] = { "select_and_accept", "fallback" },
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
fzf.setup({ 'telescope' })

local mason = require("mason")
mason.setup({})

local oil = require('oil')
oil.setup({
	default_file_explorer = true,
	columns = {
		"icon",
	},
	buf_options = {
		buflisted = false,
		bufhidden = "hide",
	},
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
	delete_to_trash = true,
	skip_confirm_for_simple_edits = false,
	prompt_save_on_select_new_entry = true,
	cleanup_delay_ms = 2000,
	lsp_file_methods = {
		timeout_ms = 1000,
		autosave_changes = false,
	},
	constrain_cursor = "editable",
	experimental_watch_for_changes = false,
	use_default_keymaps = true,
	view_options = {
		show_hidden = true,
		is_hidden_file = function(name, bufnr)
			return vim.startswith(name, ".")
		end,
		is_always_hidden = function(name, bufnr)
			return false
		end,
		natural_order = true,
		sort = {
			{ "type", "asc" },
			{ "name", "asc" },
		},
	},
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
	keymaps_help = {
		border = "rounded",
	},
})



local neogit = require('neogit')
neogit.setup({})

local luasnip = require("luasnip.loaders.from_vscode").lazy_load()


local treesitter_ctx = require("treesitter-context")
treesitter_ctx.setup({
	max_lines = 2,
	separator = "-",
	mode = "topline"
})

local map = vim.keymap.set
map("n", "<leader>p", function() plugin_view.open() end)

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
		group = augroup,
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
end

setup_ts()
setup_lsp()
