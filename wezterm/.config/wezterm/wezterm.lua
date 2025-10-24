local wezterm = require("wezterm")
local font_config = require("fonts")
local keybind_config = require("keybinds")

local config = {
	-- window_background_opacity = 0.75,
	-- macos_window_background_blur = 15,
	-- window_decorations = "RESIZE",
	window_content_alignment = {
		horizontal = 'Left',
		vertical = 'Top',
	},
	hide_tab_bar_if_only_one_tab = true,
	automatically_reload_config = true,
	enable_wayland = true,
	font = font_config.get_fonts(),
	font_size = 17.9,
	line_height = 1.12,
	freetype_load_target = "Normal",
	front_end = "OpenGL",
	color_scheme = "Tomorrow Night",
	keys = keybind_config.get_keybinds(),
	exit_behavior = "Hold",
	-- disable_default_key_bindings = true,
}

-- wezterm.log_info(config)
-- wezterm.log_error("Config Dir " .. wezterm.config_dir)
return config
