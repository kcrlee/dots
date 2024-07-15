local wezterm = require("wezterm")
local font_config = {}

function font_config.get_fonts()
	return wezterm.font_with_fallback({
		{ family = "JetBrains Mono", weight = "Medium" },
		-- 	{ family = "Hack Nerd Font Mono", weight = "Medium" },
		-- 	{ family = "Iosevka Nerd Font Mono", weight = "Medium" },
		-- 	{ family = "SauceCodePro Nerd Font Mono", weight = "Medium" },
		-- 	{ family = "FiraCode Nerd Font Mono", weight = "Regular" },
		-- 	"DengXian",
	})
end

return font_config
