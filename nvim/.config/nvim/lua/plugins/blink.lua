return {
	config = function()
		---@module 'blink.cmp'
		local blink = require("blink.cmp")
		require("luasnip.loaders.from_vscode").lazy_load()
		local source_priority = {
			snippets = 1,
			lsp = 4,
			path = 2,
			buffer = 3,
		}

		blink.setup({
			---@type blink.cmp.Config
			fuzzy = {
				implementation = "prefer_rust",
				frecency = {
					enabled = true,
				},
				use_proximity = true,
				sorts = {
					function(a, b)
						local a_priority = source_priority[a.source_id]
						local b_priority = source_priority[b.source_id]
						if a_priority ~= b_priority then
							return a_priority > b_priority
						end
					end,
				},
				prebuilt_binaries = {
					download = true,
					force_version = "1.*",
				},
			},
			signature = {
				enabled = true,
				window = {
					border = "rounded",
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
				default = { "lsp", "lazydev", "path", "snippets", "buffer" },
				per_filetype = {
					lua = { inherit_defaults = true, "lazydev" },
				},
				providers = {
					lsp = {
						name = "lsp",
						enabled = true,
						module = "blink.cmp.sources.lsp",
						score_offset = 200,
					},
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100,
					},
				},
			},
			cmdline = {
				enabled = true,
			},
			completion = {
				list = {
					selection = {
						preselect = false,
						auto_insert = false,
					},
				},
				accept = {
					auto_brackets = {
						enabled = false,
					},
				},
				menu = {
					border = "rounded",
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
					auto_show_delay_ms = 1000,
					treesitter_highlighting = true,
					window = {
						border = "rounded",
					},
				},
			},
			appearance = {
				use_nvim_cmp_as_default = false,
				nerd_font_variant = "mono",
			},

			keymap = {
				["<C-space>"] = { "show", "show_documentation", "hide_documentation", "fallback" },
				["<CR>"] = { "accept", "fallback" },
				["<C-e>"] = { "hide" },
				["<C-k>"] = { "select_prev", "fallback" },
				["<C-j>"] = { "select_next", "fallback" },
				["<C-b>"] = { "scroll_documentation_down", "fallback" },
				["<C-f>"] = { "scroll_documentation_up", "fallback" },
				["<C-l>"] = { "snippet_forward", "fallback" },
				["<C-h>"] = { "snippet_backward", "fallback" },
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
