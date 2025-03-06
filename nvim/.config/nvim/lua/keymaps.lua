--need to map leader at top so that other plugins don't interfere
vim.g.mapleader = ","

vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<cr>")
vim.keymap.set("n", "<F12>", ":UndotreeToggle <Enter>")
vim.keymap.set({ "n", "v" }, "<leader>a", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })

-- vimtex
vim.keymap.set("n", "<leader>vc", ":VimtexCompile <Enter>")
vim.keymap.set("n", "<leader>i", ":Inspect <Enter>")
