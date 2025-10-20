return {
	config = function()
		local blink = require("blink.cmp")
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
					border = "rounded",
					min_width = 10,
					max_width = 80,
					max_height = 80,
					scrollbar = false,
					treesitter_highlighting = true,
					show_documentation = true,
				},
			},
			sources = {
				default = { "lazydev", "lsp", "path", "snippets", "buffer" },
				per_filetype = {
					lua = { inherit_defaults = true, "lazydev" },
				},
				providers = {
					snippets = {
						opts = {
							friendly_snippets = true,
						},
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
					border = "rounded",
					auto_show = true,
					draw = {
						treesitter = { "lsp" },
						columns = {
							{ "label",     "label_description", gap = 1 },
							{ "kind_icon", "kind",              gap = 1 },
						},
					},
				},
				documentation = {
					auto_show = true,
					treesitter_highlighting = true,
					window = { border = "rounded" },
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
	},
	data = { build = "cargo build --release" },
	defer = true,
	src = "https://github.com/Saghen/blink.cmp",
}
