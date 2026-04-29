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
autocmd("LspAttach", {
	group = group,
	callback = function(args)
		local bufopts = { noremap = true, silent = true, buffer = args.buf }
		vim.keymap.set("n", "gd", function()
			vim.lsp.buf.definition()
		end, bufopts)
		vim.keymap.set("n", "K", function()
			vim.lsp.buf.hover({
				buffer = "rounded",
				anchor_bias = 'auto',
				zindex = 300
			})
		end, bufopts)
		vim.keymap.set("n", "<leader>vws", function()
			vim.lsp.buf.workspace_symbol()
		end, bufopts)
		vim.keymap.set("n", "M", function()
			vim.diagnostic.open_float()
		end, bufopts)
		vim.keymap.set("n", "<leader>vca", function()
			vim.lsp.buf.code_action()
		end, bufopts)
		vim.keymap.set("n", "<leader>vrr", function()
			vim.lsp.buf.references()
		end, bufopts)
		vim.keymap.set("n", "<leader>vrn", function()
			vim.lsp.buf.rename()
		end, bufopts)
		vim.keymap.set("i", "<C-h>", function()
			vim.lsp.buf.signature_help()
		end, bufopts)



		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		local methods = vim.lsp.protocol.Methods


		if client:supports_method(methods.textDocument_completion) then
			vim.lsp.completion.enable(true, client.id, args.buf, {
				autotrigger = true,
				convert = function(item)
					item.preselect = false
					return { abbr = item.label:gsub("%b()", "") }
				end,
			})
		end

		if
			not client:supports_method("textDocument/willSaveWaitUntil")
			and client:supports_method("textDocument/formatting")
		then
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = vim.api.nvim_create_augroup(group, { clear = false }),
				buffer = args.buf,
				callback = function()
					-- if we wanted LSP formatting
					-- vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
				end,
			})
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

-- Run vtsls source actions synchronously before save. addMissing must run
-- before organize/remove, or the would-be-added imports get pruned as unused.
local ts_save_kinds = {
	"source.addMissingImports.ts",
	"source.removeUnused.ts",
	"source.organizeImports.ts",
}

local function apply_ts_source_actions(bufnr)
	if vim.api.nvim_buf_get_name(bufnr):match("/node_modules/") then return end

	local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "vtsls" })
	local client = clients[1]
	if not client then return end
	local enc = client.offset_encoding or "utf-16"

	for _, kind in ipairs(ts_save_kinds) do
		local params = vim.lsp.util.make_range_params(0, enc)
		params.context = { only = { kind }, diagnostics = {} }

		local resp = client:request_sync("textDocument/codeAction", params, 2000, bufnr)
		if resp and resp.result then
			for _, action in ipairs(resp.result) do
				if not action.edit and action.data and client:supports_method("codeAction/resolve") then
					local resolved = client:request_sync("codeAction/resolve", action, 2000, bufnr)
					if resolved and resolved.result then action = resolved.result end
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
