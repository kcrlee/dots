return {
	"folke/noice.nvim",
	dependencies = {
		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
		"MunifTanjim/nui.nvim",
		-- OPTIONAL:
		--   `nvim-notify` is only needed, if you want to use the notification view.
		--   If not available, we use `mini` as the fallback
		"rcarriga/nvim-notify",
	},
	event = "VeryLazy",
	opts = {
		notify = {
			-- Noice can be used as `vim.notify` so you can route any notification like other messages
			-- Notification messages have their level and other properties set.
			-- event is always "notify" and kind can be any log level as a string
			-- The default routes will forward notifications to nvim-notify
			-- Benefit of using Noice for this is the routing and consistent history view
			enabled = true,
			view = "notify",
		},
		lsp = {
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true,
			},
		},
		presets = {
			bottom_search = true,
			command_palette = true,
			long_message_to_split = true,
			lsp_doc_border = true, -- add a border to hover docs and signature help
		},
	},
	-- stylua: ignore
	keys = {
		{ "<S-Enter>",   function() require("noice").redirect(vim.fn.getcmdline()) end,                 mode = "c",                 desc = "Redirect Cmdline" },
		{ "<leader>snl", function() require("noice").cmd("last") end,                                   desc = "Noice Last Message" },
		{ "<leader>snh", function() require("noice").cmd("history") end,                                desc = "Noice History" },
		{ "<leader>sna", function() require("noice").cmd("all") end,                                    desc = "Noice All" },
		{ "<C-f>",       function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end,  silent = true,              expr = true,              desc = "Scroll forward",  mode = { "i", "n", "s" } },
		{ "<C-p>",       function() if not require("noice.lsp").scroll(-4) then return "<c-p>" end end, silent = true,              expr = true,              desc = "Scroll backward", mode = { "i", "n", "s" } },
	},
}
