-- Built-in undotree viewer (:h undotree, pack/dist/opt/nvim.undotree).
-- Not on runtimepath by default, so packadd it once at startup.

vim.cmd.packadd("nvim.undotree")
vim.cmd.packadd("nvim.difftool")

vim.keymap.set("n", "<leader>u", function()
	require("undotree").open()
end, { silent = true, desc = "Undotree open" })
