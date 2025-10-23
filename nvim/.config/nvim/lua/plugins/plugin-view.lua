return {
	config = function()
		local plugin_view = require("plugin-view")
		plugin_view.setup({})
		vim.keymap.set("n", "<leader>p", function() require("plugin-view").open() end)
	end,
	defer = true,
	src = "https://github.com/adriankarlen/plugin-view.nvim",
}
