return {
	config = function()
		require('typst-preview').setup({
			dependencies_bin = { tinymist = 'tinymist' }
		})
	end,
	defer = true,
	src = 'https://github.com/chomosuke/typst-preview.nvim',
}
