return {
	cmd = { "expert", "--stdio" },
	filetypes = { "elixir", "eelixir", "heex", "surface" },
	root_dir = function(bufnr, on_dir)
		local fname = vim.api.nvim_buf_get_name(bufnr)
		-- limit = 2 so an umbrella app's outer mix.exs wins over the child's.
		local matches = vim.fs.find({ "mix.exs" }, { upward = true, limit = 2, path = fname })
		local child_or_root, maybe_umbrella = unpack(matches)
		on_dir(vim.fs.dirname(maybe_umbrella or child_or_root))
	end,
}
