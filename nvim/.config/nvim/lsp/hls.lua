return {
	cmd = { "haskell-language-server-wrapper", "--lsp" },
	filetypes = { "haskell", "lhaskell", "cabal" },
	root_dir = function(bufnr, on_dir)
		on_dir(vim.fs.root(bufnr, function(name)
			return name == "hie.yaml"
				or name == "stack.yaml"
				or name == "cabal.project"
				or name == "package.yaml"
				or name:match("%.cabal$") ~= nil
		end))
	end,
	settings = {
		haskell = {
			formattingProvider = "fourmolu",
			cabalFormattingProvider = "cabal-fmt",
		},
	},
}
