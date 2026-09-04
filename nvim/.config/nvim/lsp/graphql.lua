return {
	cmd = { "graphql-lsp", "server", "-m", "stream" },
	filetypes = { "typescript", "javascript", "graphql", "typescriptreact", "javascriptreact" },
	root_dir = function(bufnr, on_dir)
		on_dir(vim.fs.root(bufnr, function(name)
			return name:match("^%.graphqlrc") ~= nil
				or name:match("^%.graphql%.config%.") ~= nil
				or name:match("^graphql%.config%.") ~= nil
				or name == "package.json"
		end))
	end,
}
