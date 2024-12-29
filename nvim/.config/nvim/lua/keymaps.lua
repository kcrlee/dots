--need to map leader at top so that other plugins don't interfere
vim.g.mapleader = ","

vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<cr>")
vim.keymap.set("n", "<F12>", ":UndotreeToggle <Enter>")

--Splits
vim.keymap.set("n", "<leader>vs", ":vs <Enter>")
vim.keymap.set("n", "<leader>vh", ":split <Enter>")

-- vimtex
vim.keymap.set("n", "<leader>vc", ":VimtexCompile <Enter>")
vim.keymap.set("n", "<leader>i", ":Inspect <Enter>")
