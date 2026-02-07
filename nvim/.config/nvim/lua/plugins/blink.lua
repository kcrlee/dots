return {
	config = function()
		---@module 'blink.cmp'
		local blink = require("blink.cmp")
		blink.setup({
			---@type blink.cmp.Config
			fuzzy = {
				implementation = "prefer_rust",
				use_proximity = true,
				frecency = {
					-- Whether to enable the frecency feature
					enabled = true,
					-- Location of the frecency database
					path = vim.fn.stdpath('state') .. '/blink/cmp/frecency.dat',
					-- UNSAFE!! When enabled, disables the lock and fsync when writing to the frecency database.
					-- This should only be used on unsupported platforms (e.g. alpine, termux)
					unsafe_no_lock = false,
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
						max_items = 50,
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
	},
	data = { build = "cargo build --release" },
	defer = true,
	src = "https://github.com/Saghen/blink.cmp",
}
