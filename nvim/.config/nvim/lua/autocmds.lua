-------------------------------------------------  General ----------------------------------------
vim.api.nvim_create_autocmd("BufEnter", { command = [[set formatoptions-=cro]] })

-------------------------------------------------  CUDA files --------------------------------------
local commentGroup = vim.api.nvim_create_augroup("cuda_settings", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "cuda", "cu" },
	group = commentGroup,
	callback = function(ev)
		vim.opt_local.tabstop = 2
		vim.opt_local.softtabstop = 2
		vim.opt_local.shiftwidth = 2
		vim.bo[ev.buf].commentstring = "// %s"
	end,
})

-------------------------------------------------  Markdown files --------------------------------------
local markdownGroup = vim.api.nvim_create_augroup("markdown_settings", { clear = true })
vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = "*.md",
	group = markdownGroup,
	callback = function()
		vim.opt_local.spell = true
	end,
})

vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
	pattern = { "*.md" },
	group = markdownGroup,
	callback = function()
		vim.opt_local.spell = false
	end,
})

-- toggle concealing in md between insert and normal modes
vim.api.nvim_create_augroup("markdown_conceal", { clear = true })
vim.api.nvim_create_autocmd("InsertEnter", {
	pattern = "*.md",
	group = "markdown_conceal",
	callback = function()
		vim.opt_local.conceallevel = 0
	end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
	pattern = "*.md",
	group = "markdown_conceal",
	callback = function()
		vim.opt_local.conceallevel = 2
	end,
})

------------------------------------------------latex setup------------------------------------------------

vim.api.nvim_create_augroup("latex_settings", { clear = true })
vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = "*.tex",
	group = "latex_settings",
	callback = function()
		vim.opt_local.spell = true
	end,
})

vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
	pattern = { "*.tex" },
	group = "latex_settings",
	callback = function()
		vim.opt_local.spell = false
	end,
})
------------------------------------------------ Haskell setup ------------------------------------------------
--special settings for haskell because semantic white space languages are a PITA
vim.api.nvim_create_augroup("haskell_settings", { clear = true })
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
	pattern = { "*.hs" },
	group = "haskell_settings",
	callback = function()
		vim.opt_local.expandtab = true
		vim.opt_local.tabstop = 2
		vim.opt_local.softtabstop = 2
		vim.opt_local.shiftwidth = 2
	end,
})

vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
	pattern = { "*.hs" },
	group = "haskell_settings",
	callback = function()
		vim.opt_local.expandtab = false
		vim.opt_local.tabstop = 4
		vim.opt_local.softtabstop = 4
		vim.opt_local.shiftwidth = 4
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.hs",
	group = "haskell_settings",
	callback = function()
		vim.lsp.buf.format({ async = false })
	end,
})

-- disable adding comment on new line
------------------------------------------------ LSP setup ------------------------------------------------------------------------------------
vim.o.updatetime = 250
vim.cmd([[autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]])
local augroup = vim.api.nvim_create_augroup
local LSPGroup = augroup("LSPGroup", {})
local autocmd = vim.api.nvim_create_autocmd

autocmd({ "BufWritePre" }, {
	group = LSPGroup,
	pattern = "*",
	command = [[%s/\s\+$//e]],
})

autocmd("LspAttach", {
	group = LSPGroup,
	callback = function(e)
		local opts = { buffer = e.buf }
		vim.keymap.set("n", "gd", function()
			vim.lsp.buf.definition()
		end, opts)
		vim.keymap.set("n", "K", function()
			vim.lsp.buf.hover()
		end, opts)
		vim.keymap.set("n", "<leader>vws", function()
			vim.lsp.buf.workspace_symbol()
		end, opts)
		vim.keymap.set("n", "<leader>vd", function()
			vim.diagnostic.open_float()
		end, opts)
		vim.keymap.set("n", "<leader>vca", function()
			vim.lsp.buf.code_action()
		end, opts)
		vim.keymap.set("n", "<leader>vrr", function()
			vim.lsp.buf.references()
		end, opts)
		vim.keymap.set("n", "<leader>vrn", function()
			vim.lsp.buf.rename()
		end, opts)
		vim.keymap.set("i", "<C-h>", function()
			vim.lsp.buf.signature_help()
		end, opts)
		vim.keymap.set("n", "[d", function()
			vim.diagnostic.goto_next()
		end, opts)
		vim.keymap.set("n", "]d", function()
			vim.diagnostic.goto_prev()
		end, opts)
	end,
})

local StopNeovimDaemons = vim.api.nvim_create_augroup("StopNeovimDaemons", {})
vim.api.nvim_create_autocmd("ExitPre", {
	group = StopNeovimDaemons,
	callback = function()
		vim.fn.jobstart(vim.fn.expand("~/.local/bin/utils/stop_nvim_daemons.sh"), { detach = true })
	end,
})

------------------------------------------------ Wezterm Integrations. ------------------------------------------------

local filetype_commands = {
	python = "python3 %",
	javascript = "node %",
	typescript = "ts-node %",
	haskell = "stack build && stack test",
	lua = "lua %",
	-- Add more filetypes and commands as needed
}

local is_tmux = os.getenv("TMUX") ~= nil

if is_tmux then
	-- Function to get the Vimux command for a given filetype
	local function get_vimux_command(filetype)
		-- local command = filetype_commands[filetype]
		-- return ":VimuxRunCommand('" .. command .. " . bufname("%")')<cr>"
		local command = filetype_commands[filetype]
		local buffer_name = vim.fn.expand("%") -- Get the name of the current buffer
		print("buffer name", buffer_name)
		return ":VimuxRunCommand('" .. command:gsub("%%", buffer_name) .. "')<cr>"
	end

	-- Autocommand to set up the keymap for filetypes with Vimux commands
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "*",
		callback = function()
			local filetype = vim.bo.filetype
			if filetype_commands[filetype] then
				local vimux_command = get_vimux_command(filetype)
				vim.keymap.set("n", "<leader>rr", vimux_command, { silent = true, noremap = true })
			end
		end,
	})
else
	local function get_ft_command(filetype)
		local command = filetype_commands[filetype]
		local buffer_name = vim.fn.expand("%")
		local full_command_str = command:gsub("%%", buffer_name)
		return full_command_str
	end

	local function create_wezterm_splitpane()
		local id = vim.system(
			{ "wezterm", "cli", "split-pane", "--right", "--percent", "40" },
			{ text = true },
			function(p)
				if p.code ~= 0 then
					vim.notify(
						"Failed to create a split pane. \n" .. p.stderr,
						vim.logs.levels.ERROR,
						{ title = "Wezterm" }
					)
				end
			end
		)
			:wait()

		local stripped_id = string.gsub(id.stdout, "%s+", "")
		return stripped_id
	end

	local function send_text_to_wezterm(pane_id, full_command_str)
		local result = vim.system(
			{ "wezterm", "cli", "send-text", "--no-paste", "--pane-id", pane_id, full_command_str .. "\r" },
			{ text = true },
			function(p)
				return p
			end
		):wait()
		return result
	end

	local repl_pane_id = nil
	local function create_repl_pane(ft_command)
		return function()
			if repl_pane_id == nil then
				repl_pane_id = create_wezterm_splitpane()
			end

			local result = send_text_to_wezterm(repl_pane_id, ft_command)
			if repl_pane_id ~= nil and result.code ~= 0 then
				repl_pane_id = create_wezterm_splitpane()
				result = send_text_to_wezterm(repl_pane_id, ft_command)
			end

			if result.code ~= 0 then
				vim.notify(
					"Failed to move to send text to pane:" .. repl_pane_id .. " \n" .. result.stderr,
					vim.log.levels.ERROR,
					{ title = "Wezterm" }
				)
			end
		end
	end
	-- Autocommand to set up the keymap for filetypes with Wezterm
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "*",
		callback = function()
			local filetype = vim.bo.filetype
			if filetype_commands[filetype] then
				local ft_command = get_ft_command(filetype)
				vim.keymap.set("n", "<leader>rr", create_repl_pane(ft_command), { silent = true, noremap = true })
			end
		end,
	})
end
