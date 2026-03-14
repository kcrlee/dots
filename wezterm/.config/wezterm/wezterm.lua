require("wezterm")
local font_config = require("fonts")
local keybind_config = require("keybinds")

local config = {
	window_content_alignment = {
		horizontal = "Left",
		vertical = "Top",
	},
	hide_tab_bar_if_only_one_tab = false,
	automatically_reload_config = true,
	enable_wayland = true,
	font = font_config.get_fonts(),
	font_size = 18,
	line_height = 1.1,
	color_scheme = "Tomorrow Night",
	keys = keybind_config.get_keybinds(),
	exit_behavior = "Hold",
	ssh_domains = {
		{
			name = "pi",
			remote_address = "100.100.94.39",
			username = "kyle"
		}
	}
}

return config
