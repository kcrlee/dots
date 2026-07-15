vim.pack.add({ "https://github.com/nvim-tree/nvim-web-devicons" })

-- Reuse devicons' own icon defs rather than transcribing nerd-font
-- glyphs here. devicons only matches exact filenames, so each
-- conventional .env variant needs its own entry.
local by_filename = require("nvim-web-devicons.default.icons_by_filename")
local by_extension = require("nvim-web-devicons.default.icons_by_file_extension")
local env_icon = by_filename[".env"]
local cabal_icon = vim.tbl_extend("force", {}, by_extension["hs"], { name = "Cabal" })
require("nvim-web-devicons").setup({
	override_by_extension = {
		cabal = cabal_icon,
	},
	override_by_filename = {
		[".env.local"] = env_icon,
		[".env.development"] = env_icon,
		[".env.production"] = env_icon,
		[".env.test"] = env_icon,
		[".env.staging"] = env_icon,
		[".env.example"] = env_icon,
		[".env.sample"] = env_icon,
		[".env.development.local"] = env_icon,
		[".env.production.local"] = env_icon,
		[".env.test.local"] = env_icon,
		["*.vars"] = env_icon,
	},
})
