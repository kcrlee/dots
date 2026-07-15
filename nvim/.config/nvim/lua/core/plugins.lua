-- Each file in lua/plugins/ is self-contained: it vim.pack.add()s what it
-- needs and configures it. Update plugins with :lua vim.pack.update(),
-- remove unused ones with :lua vim.pack.del({ "name" }).
for _, fpath in ipairs(vim.fn.glob(vim.fn.stdpath("config") .. "/lua/plugins/*.lua", true, true)) do
	require("plugins." .. vim.fn.fnamemodify(fpath, ":t:r"))
end
