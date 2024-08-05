return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"rcarriga/nvim-dap-ui",
	},
	config = function()
		local dap = require("dap")
		local dapUI = require("dapui")
		-- local go = require("dap-go")
		dapUI.setup()
		-- go.setup()

		-- Adapters
		-- C, C++, Rust
		dap.adapters.codelldb = {
			type = "server",
			port = "${port}",
			executable = {
				command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
				-- codelldb",
				args = { "--port", "${port}" },
			},
		}

		dap.listeners.before.attach.dapui_config = function()
			dapUI.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapUI.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapUI.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapUI.close()
		end

		vim.fn.sign_define("DapBreakpoint", { text = "🟥", texthl = "", linehl = "", numhl = "" })
		vim.fn.sign_define("DapStopped", { text = "⭐️", texthl = "", linehl = "", numhl = "" })

		vim.keymap.set("n", "<Leader>dt", dap.toggle_breakpoint, {})
		vim.keymap.set("n", "<Leader>dn", dap.continue, {})
	end,
}
