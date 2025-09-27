local function gh(url)
	return "https://github.com/" .. url
end

local function add_plugin(plugins, opts)
	opts = opts or {}
	local function do_add(plugs)
		vim.pack.add(plugs)
		for _, plug in ipairs(plugs) do
			if type(plug) == "string" then
				plug = { src = plug }
			end
			local name = plug.name or plug.src
			name = vim.fs.basename(name)
			name = name:gsub("%.n?vim", "")
			name = name:gsub("%.", "-")
			pcall(require, "plugins." .. name)
		end
	end

	do_add(plugins)
end
