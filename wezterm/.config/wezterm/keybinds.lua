local wezterm = require("wezterm")
local act = wezterm.action
local utils = require("utils")
-- Primary Actions mapped to ALT (moving self around)
-- Secondary Actions mapped to ALT|SHIFT (moving objects around)

local keybind_config = {}

function keybind_config.get_keybinds()
	local keys = {
		-- Closing the current split
		{
			key = "w",
			mods = "ALT|SHIFT",
			action = act({ CloseCurrentPane = { confirm = true } }),
		},

		{
			key = "p",
			mods = "ALT|SHIFT",
			action = wezterm.action.TogglePaneZoomState,
		},

		-- Spawning a new split left-right)
		{
			key = "|",
			mods = "ALT|SHIFT",
			action = act({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
		},

		-- Spawning a new split (top-down)
		{
			key = "Enter",
			mods = "ALT|SHIFT",
			action = act({ SplitVertical = { domain = "CurrentPaneDomain" } }),
		},
		-- Cycle through splits
		{
			key = "[",
			mods = "ALT",
			action = act({ ActivatePaneDirection = "Next" }),
		},

		{
			key = "]",
			mods = "ALT",
			action = act({ ActivatePaneDirection = "Prev" }),
		},

		-- Changing the layout of the splits
		{
			key = "}",
			mods = "ALT|SHIFT",
			action = act.RotatePanes("Clockwise"),
		},
		{
			key = "{",
			mods = "ALT|SHIFT",
			action = act.RotatePanes("CounterClockwise"),
		},
		{
			mods = "CTRL",
			key = "i",
			action = wezterm.action_callback(function(win, pane)
				wezterm.log_info("Hello from callback!")
				wezterm.log_info("WindowID:", win:window_id(), "PaneID:", pane:pane_id())
			end),
		},
		{
			key = "L",
			mods = "CTRL|SHIFT",
			action = act.ShowDebugOverlay,
		},
		--TODO:
		--1. bind to action that can be emitted from nvim so that I my thumb doesn't get fucked.
		--2. Add error handling so I don't go insane trying to debug this
		{
			key = "T",
			mods = "ALT|SHIFT",
			action = wezterm.action_callback(function(window, pane)
				local tab_title = window:active_tab():get_title()
				local is_running_nvim = tab_title.find(tab_title, "nvim")
				if not is_running_nvim then
					wezterm.log_error(
						"No nvim instance was found. Either the tab title was unsucessfully set to the filename from within neovim or another error occurred."
					)
					return 0
				end

				local file_name = tab_title:match("%S+%.%S+")
				local file_type = utils.get_file_type(tab_title)
				local command = utils.compile_and_run_tests(file_type, file_name)
				local curr_dir = window:active_pane():get_current_working_dir()

				if command == nil then
					wezterm.log_error("No command found for file of type: " .. file_type .. ".")
					return 0
				end

				window:perform_action(
					act.SpawnCommandInNewWindow({
						args = {
							os.getenv("SHELL"),
							"-c",
							command,
						},
						cwd = curr_dir.file_path,
					}),
					pane
				)
			end),
		},
		{
			key = "t",
			mods = "ALT",
			action = wezterm.action_callback(function(window, pane)
				local tab_title = window:active_tab():get_title()
				local is_running_nvim = tab_title.find(tab_title, "nvim")
				if not is_running_nvim then
					wezterm.log_error(
						"No nvim instance was found. Either the tab title was unsucessfully set to the filename from within neovim or another error occurred."
					)
					return 0
				end

				local file_type = utils.get_file_type(tab_title)

				local file_name = tab_title:match("%S+%.%S+")
				local command = utils.compile_and_run_file(file_type, file_name)
				local curr_dir = window:active_pane():get_current_working_dir()

				if command == nil then
					wezterm.log_error("No command found for file of type: " .. file_type .. ".")
					return 0
				end

				window:perform_action(
					act.SpawnCommandInNewWindow({
						args = {
							os.getenv("SHELL"),
							"-c",
							command,
						},
						cwd = curr_dir.file_path,
					}),
					pane
				)
			end),
		},
	}
	return keys
end

return keybind_config
