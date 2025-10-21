return {
	config = function()
		local blink = require("blink.cmp")
		require("luasnip.loaders.from_vscode").lazy_load()
		blink.setup({
			fuzzy = {
				implementation = "prefer_rust",
				frecency = {
					enabled = true,
				},
				use_proximity = true,
				prebuilt_binaries = {
					download = true,
					force_version = "1.*",
				},
			},
			signature = {
				enabled = true,
				window = {
					border = "double",
					min_width = 10,
					max_width = 80,
					max_height = 80,
					scrollbar = false,
					treesitter_highlighting = true,
					show_documentation = true,
				},
			},
			snippets = { preset = "default" },
			sources = {
				default = { "lazydev", "lsp", "path", "snippets", "buffer", "emoji" },
				per_filetype = {
					lua = { inherit_defaults = true, "lazydev" },
				},
				providers = {
					lsp = {
						name = "lsp",
						enabled = true,
						module = "blink.cmp.sources.lsp",
					},
					emoji = {
						module = "blink-emoji",
						name = "Emoji",
						score_offset = 15, -- Tune by preference
						opts = {
							insert = true, -- Insert emoji (default) or complete its name
							---@type string|table|fun():table
							trigger = function()
								return { ":" }
							end,
						},
						should_show_items = function()
							return vim.tbl_contains(
							-- Enable emoji completion only for git commits and markdown.
							-- By default, enabled for all file-types.
								{ "gitcommit", "markdown" },
								vim.o.filetype
							)
						end,
					},
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100,
					},
				},
			},
			completion = {
				list = {
					selection = {
						preselect = false,
						auto_insert = true,
					},
				},
				accept = {
					auto_brackets = {
						enabled = false,
					},
				},
				menu = {
					window = {
						border = "double",
					},
					auto_show = true,
					draw = {
						treesitter = { "lsp" },
						columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "source_name" } },
						components = {
							source_name = {
								width = { max = 30 },
								text = function(ctx)
									return "[" .. ctx.source_name .. "]"
								end,
								highlight = "BlinkCmpSource",
							},
						},
					},
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
					treesitter_highlighting = true,
					window = {
						border = "double",
					},
				},
			},
			appearance = {
				use_nvim_cmp_as_default = false,
				nerd_font_variant = "mono",
			},
			keymap = {
				preset = "default",
				["<K>"] = { "show", "show_documentation", "hide_documentation", "fallback" },
				["<CR>"] = { "select_and_accept", "fallback" },
				["<C-k>"] = { "select_prev", "fallback" },
				["<C-j>"] = { "select_next", "fallback" },
				["<C-b>"] = { "scroll_documentation_down", "fallback" },
				["<C-f>"] = { "scroll_documentation_up", "fallback" },
				["<C-l>"] = { "snippet_forward", "fallback" },
				["<C-h>"] = { "snippet_backward", "fallback" },
				["<C-e>"] = { "hide" },
			},
		})
	end,
	dependencies = {
		{
			defer = true,
			src = "https://github.com/nvim-lua/plenary.nvim",
		},
		{
			defer = true,
			src = "https://github.com/L3MON4D3/LuaSnip",
		},
		{
			defer = true,
			src = "https://github.com/rafamadriz/friendly-snippets",
		},

		{
			defer = true,
			src = "https://github.com/moyiz/blink-emoji.nvim",
		},
	},
	data = { build = "cargo build --release" },
	defer = true,
	src = "https://github.com/Saghen/blink.cmp",
}
