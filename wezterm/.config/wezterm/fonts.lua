local wezterm = require("wezterm")
local font_config = {}

function font_config.get_fonts()
	return wezterm.font_with_fallback({
		{
			family = "Berkeley Mono",
			weight = "Regular",
		},
		{ family = "JetBrains Mono",      weight = "Medium", harfbuzz_features = { "calt=0", "clig=0", "liga=0" } },
		{ family = "Hack Nerd Font Mono", weight = "Medium" },
	})
end

return font_config
