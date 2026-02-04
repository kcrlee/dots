return {
	config = function()
		local mc = require("multicursor-nvim")
		mc.setup()

		local set = vim.keymap.set

		-- Add or skip cursor above/below the main cursor.
		set({ "n", "x" }, "<up>", function() mc.lineAddCursor(-1) end)
		set({ "n", "x" }, "<down>", function() mc.lineAddCursor(1) end)
		set({ "n", "x" }, "<leader><up>", function() mc.lineSkipCursor(-1) end)
		set({ "n", "x" }, "<leader><down>", function() mc.lineSkipCursor(1) end)

		-- Add or skip adding a new cursor by matching word/selection
		set({ "n", "x" }, "<leader>n", function() mc.matchAddCursor(1) end)
		set({ "n", "x" }, "<leader>s", function() mc.matchSkipCursor(1) end)
		set({ "n", "x" }, "<leader>N", function() mc.matchAddCursor(-1) end)
		set({ "n", "x" }, "<leader>S", function() mc.matchSkipCursor(-1) end)

		-- Add and remove cursors with control + left click.
		set("n", "<c-leftmouse>", mc.handleMouse)
		set("n", "<c-leftdrag>", mc.handleMouseDrag)
		set("n", "<c-leftrelease>", mc.handleMouseRelease)

		-- Disable and enable cursors.
		set({ "n", "x" }, "<c-q>", mc.toggleCursor)
	end,
	src = "https://github.com/jake-stewart/multicursor.nvim",
	defer = true,
}
