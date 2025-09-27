local function gh(url)
	return "https://github.com/" .. url
end

local function add_plugin(plugins, opts)
	opts = opts or {}
	local function do_add(plugs)
		vim.pack.add(plugs)
		for _, plug in ipairs(plugs) do
			if type(plug) == "string" then
				plug = { src = plug }
			end
			local name = plug.name or plug.src
			name = vim.fs.basename(name)
			name = name:gsub("%.n?vim", "")
			name = name:gsub("%.", "-")
			pcall(require, "plugins." .. name)
		end
	end

	do_add(plugins)
end

add_plugin({
	gh("nvim-lua/plenary.nvim"),
	gh("nvim-tree/nvim-web-devicons"),
	gh("stevearc/oil.nvim"),
	gh("kcrlee/tomorrow-min"),
	gh("mason-org/mason.nvim"),
	gh("nvim-treesitter/nvim-treesitter"),
	gh("NeogitOrg/neogit"),
	gh("stevearc/oil.nvim"),
	gh("ibhagwan/fzf-lua"),
	gh("folke/snacks.nvim"),
	gh("folke/trouble.nvim"),
	gh("folke/lazydev.nvim"),
	gh("saghen/blink.nvim"),
})

vim.cmd("colorscheme tomorrow-min")

-- local fzf = require("fzf-lua")
-- local map = vim.keymap.set
-- map("n", "<leader>g", require("neogit").open)
-- map("n", "<F12>", ":UndotreeToggle <Enter>")
-- map("n", "<leader>vc", ":VimtexCompile <Enter>")
-- map("n", "<leader>i", ":Inspect <Enter>")
-- map("n", "<leader>ff", fzf.files)
-- map("n", "<leader>fg", fzf.live_grep)
-- map("n", "-", ":Oil<CR>")
