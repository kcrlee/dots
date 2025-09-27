local fzf = require("fzf-lua")
local map = vim.keymap.set
map("n", "<leader>g", require("neogit").open)
map("n", "<F12>", ":UndotreeToggle <Enter>")
map("n", "<leader>vc", ":VimtexCompile <Enter>")
map("n", "<leader>i", ":Inspect <Enter>")
map("n", "<leader>ff", fzf.files)
map("n", "<leader>fg", fzf.live_grep)
map("n", "-", ":Oil<CR>")
