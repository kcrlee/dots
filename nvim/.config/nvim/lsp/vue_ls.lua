-- NOTE: vue_ls runs in hybrid mode and forwards TypeScript requests to a
-- tsserver-based client (ts_ls or vtsls) via typescript.tsserverRequest.
-- tsgo does not implement that command, so with tsgo as the only TS server
-- this handler retries then logs an error, and Vue files get template-side
-- features only. This mirrors what nvim-lspconfig does today.
return {
	cmd = { "vue-language-server", "--stdio" },
	filetypes = { "vue" },
	root_markers = { "package.json" },
	on_init = function(client)
		local retries = 0
		local function typescript_handler(_, result, context)
			local ts_client = vim.lsp.get_clients({ bufnr = context.bufnr, name = "ts_ls" })[1]
				or vim.lsp.get_clients({ bufnr = context.bufnr, name = "vtsls" })[1]
			if not ts_client then
				if retries <= 10 then
					retries = retries + 1
					vim.defer_fn(function()
						typescript_handler(_, result, context)
					end, 100)
				else
					vim.notify("vue_ls: no ts_ls/vtsls client to forward tsserver requests to", vim.log.levels.ERROR)
				end
				return
			end
			local param = unpack(result)
			local id, command, payload = unpack(param)
			ts_client:exec_cmd({
				title = "vue_request_forward",
				command = "typescript.tsserverRequest",
				arguments = { command, payload },
			}, { bufnr = context.bufnr }, function(_, r)
				client:notify("tsserver/response", { { id, r and r.body } })
			end)
		end
		client.handlers["tsserver/request"] = typescript_handler
	end,
}
