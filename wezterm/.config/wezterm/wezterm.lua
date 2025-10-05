local wezterm = require("wezterm")
local font_config = require("fonts")
local keybind_config = require("keybinds")
local utils = require("utils")

local config = {
	-- window_background_opacity = 0.75,
	-- macos_window_background_blur = 15,
	window_decorations = "RESIZE",
	hide_tab_bar_if_only_one_tab = true,
	automatically_reload_config = true,
	enable_wayland = true,
	font = font_config.get_fonts(),
	font_size = 16.0,
	color_scheme = "Tomorrow Night",
	keys = keybind_config.get_keybinds(),
	exit_behavior = "Hold",
	-- disable_default_key_bindings = true,
}

local host_os = utils.detect_host_os()
local ghcup_PATH = "/Users/kyle/.ghcup/bin:"
local bin_PATH = "/usr/local/bin:" .. os.getenv("PATH")
local brew_PATH = "/opt/homebrew/bin/:"
local node_PATH = "/Users/kyle/.nvm/versions/node/v21.0.0/bin:"
local pnpm_PATH = "/Users/kyle/.nvm/versions/node/v21.0.0/bin:"

local PATH_ENV_VARS = ghcup_PATH .. bin_PATH .. brew_PATH .. node_PATH .. pnpm_PATH
if host_os == "macos" then
	-- check homebrew binary symlinks on startup.
	config.set_environment_variables = {
		PATH = PATH_ENV_VARS,
	}
end
-- wezterm.log_info(config)
-- wezterm.log_error("Config Dir " .. wezterm.config_dir)
return config
