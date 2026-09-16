vim.pack.add({ "https://github.com/ibhagwan/fzf-lua" })

local fzf = require("fzf-lua")
fzf.setup({ "telescope" })

vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "Fzf files" })
vim.keymap.set("n", "<leader>fg", fzf.live_grep, { desc = "Fzf live grep" })
