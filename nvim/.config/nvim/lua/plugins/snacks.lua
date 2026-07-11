return {
	config = function()
		local snacks = require("snacks")
		snacks.setup({
			image = { enabled = true },
			bigfile = { enabled = true },
			explorer = { enabled = false },
			terminal = { enabled = true }
		})
	end,
	-- Not deferred: claudecode.nvim is eager and its snacks terminal provider
	-- caches `pcall(require, "snacks")` at setup time. If Snacks is deferred it
	-- isn't on the runtimepath yet, so claudecode caches "snacks unavailable"
	-- and warns on every cursor move. Loading Snacks eagerly fixes that.
	src = "https://github.com/folke/snacks.nvim",
}
