local wezterm = require("wezterm")
local font_config = require("fonts")
local keybind_config = require("keybinds")
-- local utils = require("utils")
local ssh_domains = {
	{
		-- the name	to use for the 'wezterm connect' command
		name = "uchicago",
		username = "kchow1",
		remote_address = "linux.cs.uchicago.edu",
		multiplexing = "None",
		-- if you know that the remote host has a posix/unix environment,
		-- setting assume_shell = "Posix" will result in new panes respecting
		-- the remote current directory when multiplexing = "None".
		-- assume_shell = "Posix",
	},
}
local config = {
	ssh_domains = ssh_domains,
	-- window_background_opacity = 0.75,
	-- macos_window_background_blur = 15,
	window_decorations = "NONE",
	hide_tab_bar_if_only_one_tab = true,
	automatically_reload_config = true,
	enable_wayland = true,
	font = font_config.get_fonts(),
	font_size = 16.0,
	-- color_scheme = "Dark+",
	-- keys = keybind_config.get_keybinds(),
	exit_behavior = "Hold",
	default_prog = { "/bin/zsh", "-l" },
}

-- local host_os = utils.detect_host_os()
-- local ghcup_PATH = "/Users/kyle/.ghcup/bin:"
-- local bin_PATH = "/usr/local/bin:" .. os.getenv("PATH")
-- local brew_PATH = "/opt/homebrew/bin/:"
-- local node_PATH = "/Users/kyle/.nvm/versions/node/v21.0.0/bin:"
-- local pnpm_PATH = "/Users/kyle/.nvm/versions/node/v21.0.0/bin:"
--
-- local PATH_ENV_VARS = ghcup_PATH .. bin_PATH .. brew_PATH .. node_PATH .. pnpm_PATH
-- if host_os == "macos" then
-- 	-- check homebrew binary symlinks on startup.
-- 	config.set_environment_variables = {
-- 		PATH = PATH_ENV_VARS,
-- 	}
-- end
-- wezterm.log_info(config)
-- wezterm.log_error("Config Dir " .. wezterm.config_dir)
return config
