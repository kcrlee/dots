vim.pack.add({ "https://github.com/folke/sidekick.nvim" })

-- Two Claude Code profiles, mirroring the `claude` / `claude-work` zsh aliases.
-- Sidekick passes `env` to the spawned process (false = unset), so the
-- personal tool clears CLAUDE_CONFIG_DIR and the work tool sets it.
--
-- `is_proc` is what sidekick uses to attribute an already-running process in
-- a tmux pane to a tool. macOS no longer exposes other processes' environment
-- to `ps`, so the work tool runs through a non-exec `sh -c` wrapper whose
-- command line carries a "claude-work" marker that `is_proc` can see.
local work_config_dir = vim.env.HOME .. "/.claude-work"
local claude_spec = dofile(vim.api.nvim_get_runtime_file("sk/cli/claude.lua", false)[1])

local claude_work = vim.tbl_deep_extend("force", claude_spec, {
	-- The trailing `:` stops sh from exec-ing claude, so the wrapper stays in
	-- the process tree. $0 is "claude-work"; "$@" forwards any extra args.
	cmd = { "sh", "-c", 'claude "$@"; :', "claude-work" },
	env = { CLAUDE_CONFIG_DIR = work_config_dir },
	is_proc = "\\<claude-work\\>",
})

require("sidekick").setup({
	-- NES (Next Edit Suggestions) is served by copilot-language-server,
	-- enabled in lsp.lua. Sign in once with :LspCopilotSignIn.
	cli = {
		-- Runs the CLI in a Neovim split. Set enabled = true to hand the
		-- session to tmux/zellij instead when running inside one.
		mux = { enabled = false },
		tools = {
			claude = {
				env = { CLAUDE_CONFIG_DIR = false },
				is_proc = function(_, proc)
					return proc.cmd:match("%f[%w]claude%f[%W]") ~= nil
						and not proc.cmd:find("claude-work", 1, true)
				end,
			},
			claude_work = claude_work,
		},
	},
})

local map = vim.keymap.set
local cli = function()
	return require("sidekick.cli")
end

-- Insert-mode <Tab> is handled by blink.lua so it can chain with snippets
-- and inline completion.
map("n", "<Tab>", function()
	if not require("sidekick").nes_jump_or_apply() then
		return "<Tab>"
	end
end, { expr = true, desc = "Sidekick goto/apply next edit suggestion" })

map({ "n", "t", "i", "x" }, "<c-.>", function()
	cli().focus()
end, { desc = "Sidekick focus" })

map("n", "<leader>aa", function()
	cli().toggle()
end, { desc = "Sidekick toggle CLI" })

map("n", "<leader>as", function()
	cli().select()
end, { desc = "Sidekick select CLI" })

map("n", "<leader>ad", function()
	cli().close()
end, { desc = "Sidekick detach CLI session" })

map({ "n", "x" }, "<leader>at", function()
	cli().send({ msg = "{this}" })
end, { desc = "Sidekick send this" })

map("n", "<leader>af", function()
	cli().send({ msg = "{file}" })
end, { desc = "Sidekick send file" })

map("x", "<leader>av", function()
	cli().send({ msg = "{selection}" })
end, { desc = "Sidekick send selection" })

map({ "n", "x" }, "<leader>ap", function()
	cli().prompt()
end, { desc = "Sidekick select prompt" })

map("n", "<leader>ac", function()
	cli().toggle({ name = "claude", focus = true })
end, { desc = "Sidekick toggle Claude" })

map("n", "<leader>aw", function()
	cli().toggle({ name = "claude_work", focus = true })
end, { desc = "Sidekick toggle Claude (work)" })
