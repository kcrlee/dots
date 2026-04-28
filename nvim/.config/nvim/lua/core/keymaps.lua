local map = vim.keymap.set

-- Completion: pum-aware mappings to mirror the old blink keymap
local pum = function() return vim.fn.pumvisible() == 1 end
map("i", "<CR>",      function() return pum() and "<C-y>" or "<CR>" end, { expr = true })
map("i", "<C-j>",     function() return pum() and "<C-n>" or "<C-j>" end, { expr = true })
map("i", "<C-k>",     function() return pum() and "<C-p>" or "<C-k>" end, { expr = true })
map("i", "<C-e>",     function() return pum() and "<C-e>" or "<C-e>" end, { expr = true })
map("i", "<C-Space>", function()
	if pum() then return "<C-e>" end
	vim.lsp.completion.get()
	return ""
end, { expr = true })

-- Snippet jumps (vim.snippet)
map({ "i", "s" }, "<C-l>", function()
	if vim.snippet.active({ direction = 1 }) then vim.snippet.jump(1) end
end)
map({ "i", "s" }, "<C-h>", function()
	if vim.snippet.active({ direction = -1 }) then vim.snippet.jump(-1) end
end)

map("n", "<F12>", ":UndotreeToggle <Enter>")

map("n", "<leader>i", ":Inspect <Enter>")

map("n", "<leader>ff", ":FzfLua files<Enter>")
map("n", "<leader>fg", ":FzfLua live_grep<Enter>")

map("n", "-", ":Oil<CR>")

map("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", { silent = true, noremap = true })
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { silent = true, noremap = true })
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { silent = true, noremap = true })
map("n", "<leader>g", require("neogit").open)

map("n", "<leader>.", function()
	require("snacks").scratch()
end, { silent = true, noremap = true })

map("n", "<leader>S", function()
	require("snacks").scratch.select()
end, { silent = true, noremap = true })
map("n", "<leader>nn", "<cmd>NoNeckPain<cr>", { silent = true, noremap = true })
map('n', "<leader>u", "require('undotree').open", { silent = true, noremap = true })
