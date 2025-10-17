return {
	config = function()
		local blink = require("blink.cmp")

		-- require("luasnip.loaders.from_lua").lazy_load()

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
					min_width = 1,
					max_width = 100,
					max_height = 10,
					winblend = 0,

					border = nil,
					scrollbar = false,
					treesitter_highlighting = true,
					show_documentation = true,
				},
			},
			appearance = {
				nerd_font_variant = "mono",
			},
			snippets = {
				-- preset = "luasnip",
				friendly_snippets = true, -- default
			},
			sources = {
				default = { "lazydev", "lsp", "path", "snippets", "buffer" },
				providers = {
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
						-- When `true`, will automatically select the first item in the completion list
						preselect = false,
						-- preselect = function(ctx) return vim.bo.filetype ~= 'markdown' end,

						-- When `true`, inserts the completion item automatically when selecting it
						-- You may want to bind a key to the `cancel` command (default <C-e>) when using this option,
						-- which will both undo the selection and hide the completion menu
						auto_insert = true,
						-- auto_insert = function(ctx) return vim.bo.filetype ~= 'markdown' end
					},
				},
				accept = {
					auto_brackets = {
						enabled = false,
					},
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
				},
				menu = {
					auto_show = true,
					draw = {
						padding = { 1, 1 }, -- padding only on right side
						components = {
							kind_icon = {
								text = function(ctx)
									return " " .. ctx.kind_icon .. ctx.icon_gap .. " "
								end,
							},
						},
					},
				},
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
	},
	data = { build = "cargo build --release" },
	defer = true,
	src = "https://github.com/Saghen/blink.cmp",
}
