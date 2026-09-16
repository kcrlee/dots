local group = "init"

local autocmd = vim.api.nvim_create_autocmd

vim.api.nvim_create_augroup(group, { clear = true })

vim.cmd([[autocmd BufEnter * set formatoptions-=cro]])

autocmd({ "BufReadPre", "BufNewFile", "BufWritePost" }, {
	group = group,
	callback = function()
		require("lint").try_lint()
	end,
})

autocmd("PackChanged", {
	group = group,
	callback = function(ev)
		local spec = ev.data.spec
		if spec and spec.name == "nvim-treesitter" and ev.data.kind == "update" then
			vim.schedule(function()
				local ts = require("nvim-treesitter")
				ts.update()
			end)
		end
	end,
})

autocmd("FileType", {
	group = group,
	callback = function(ev)
		local filetype = ev.match
		local lang = vim.treesitter.language.get_lang(filetype)
		if lang then
			if vim.treesitter.language.add(lang) then
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				vim.treesitter.start()
			end
		end
	end,
})

-- Apply the server's bulk auto-fixes on save. TypeScript 7 does not implement
-- source.addMissingImports; source.fixAll is the nearest kind and currently
-- covers missing imports, isolated-declarations, and class-implements fixes.
-- Removing unused / organizing imports is a separate kind and is intentionally
-- skipped so in-progress code isn't pruned mid-edit.
local ts_save_kinds = {
	"source.fixAll",
}

local function apply_ts_source_actions(bufnr)
	if vim.api.nvim_buf_get_name(bufnr):match("/node_modules/") then
		return
	end

	local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "tsc" })
	local client = clients[1]
	if not client then
		return
	end
	local enc = client.offset_encoding or "utf-16"

	for _, kind in ipairs(ts_save_kinds) do
		local params = vim.lsp.util.make_range_params(0, enc)
		params.context = { only = { kind }, diagnostics = {} }

		local resp = client:request_sync("textDocument/codeAction", params, 2000, bufnr)
		if resp and resp.result then
			for _, action in ipairs(resp.result) do
				if not action.edit and action.data and client:supports_method("codeAction/resolve") then
					local resolved = client:request_sync("codeAction/resolve", action, 2000, bufnr)
					if resolved and resolved.result then
						action = resolved.result
					end
				end
				if action.edit then
					vim.lsp.util.apply_workspace_edit(action.edit, enc)
				end
				if action.command then
					local cmd = type(action.command) == "table" and action.command or { command = action.command }
					client:exec_cmd(cmd, { bufnr = bufnr })
				end
			end
		end
	end
end

autocmd("BufWritePre", {
	group = group,
	pattern = { "*.ts", "*.tsx", "*.js", "*.jsx", "*.mts", "*.cts", "*.mjs", "*.cjs" },
	callback = function(args)
		apply_ts_source_actions(args.buf)
	end,
})
