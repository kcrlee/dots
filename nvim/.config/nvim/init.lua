vim.o.wrap = false
vim.o.relativenumber = true
vim.o.number = true
vim.o.swapfile= false
vim.o.tabstop = 4

vim.g.mapleader = ","



vim.pack.add({
	{src="https://github.com/stevearc/oil.nvim"},
	{src="https://github.com/rebelot/kanagawa.nvim"}
})

vim.cmd("colorscheme kanagawa-dragon")




-- LSP
vim.lsp.enable("luals", "ts_ls")


vim.lsp.config('lua_ls', {
  root_dir = function(bufnr, on_dir)
    if not vim.fn.bufname(bufnr):match('%.txt$') then
      on_dir(vim.fn.getcwd())
    end
  end
})
