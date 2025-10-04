return {
	config = function()
		local blink = require("blink.cmp")

		require("luasnip.loaders.from_lua").lazy_load()

		blink.setup({
			fuzzy = {
				implementation = "prefer_rust",
				frecency = {
					enabled = true,
				},
				prebuilt_binaries = {
					download = true,
					force_version = "1.*",
				},
			},
			signature = {
				enabled = true,
				window = { border = "single" },
			},
			appearance = {
				nerd_font_variant = "mono",
			},
			snippets = {
				preset = "luasnip",
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
						padding = { 0, 1 }, -- padding only on right side
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
