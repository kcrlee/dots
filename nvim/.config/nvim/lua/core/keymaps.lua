local map = vim.keymap.set
map("n", "<leader>i", ":Inspect <Enter>")

map("n", "<leader>ff", ":FzfLua files<Enter>")
map("n", "<leader>fg", ":FzfLua live_grep<Enter>")

map("n", "-", ":Oil<CR>")

map("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", { silent = true, noremap = true })
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { silent = true, noremap = true })
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { silent = true, noremap = true })

map("n", "<leader>.", function()
	require("snacks").scratch()
end, { silent = true, noremap = true })

map("n", "<leader>S", function()
	require("snacks").scratch.select()
end, { silent = true, noremap = true })

map("n", "<leader>u", function()
	require("undotree").open()
end, { silent = true, noremap = true })

map("n", "<leader>g", function()
	require("neogit").open()
end, { silent = true, noremap = true })

-- Completion (native vim.lsp.completion; see autocmds.lua LspAttach).
local function pum(key, fallback)
	return function()
		return vim.fn.pumvisible() == 1 and key or fallback
	end
end
map("i", "<C-space>", function()
	vim.lsp.completion.get()
end, { desc = "Trigger LSP completion" })
map("i", "<C-j>", pum("<C-n>", "<C-j>"), { expr = true })
map("i", "<C-k>", pum("<C-p>", "<C-k>"), { expr = true })
map("i", "<CR>", pum("<C-y>", "<CR>"), { expr = true })
map("i", "<C-b>", pum("<PageDown>", "<C-b>"), { expr = true })
map("i", "<C-f>", pum("<PageUp>", "<C-f>"), { expr = true })

-- Snippets (vim.snippet; <Tab>/<S-Tab> also jump by default).
map({ "i", "s" }, "<C-l>", function()
	if vim.snippet.active({ direction = 1 }) then
		vim.snippet.jump(1)
	end
end)
map({ "i", "s" }, "<C-h>", function()
	if vim.snippet.active({ direction = -1 }) then
		vim.snippet.jump(-1)
	end
end)
