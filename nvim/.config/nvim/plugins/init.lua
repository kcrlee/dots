-- plugins/init.lua
local M = {}

local function scan_dir(directory)
  local plugins = {}
  local pfile = io.popen('find "' .. directory .. '" -name "*.lua" -not -name "init.lua"')
  
  if pfile then
    for filename in pfile:lines() do
      local plugin_name = filename:match("([^/]+)%.lua$")
      if plugin_name then
        local ok, plugin_config = pcall(require, "plugins." .. plugin_name)
        if ok and plugin_config then
          table.insert(plugins, plugin_config)
        end
      end
    end
    pfile:close()
  end
  
  return plugins
end

M = scan_dir(vim.fn.stdpath("config") .. "/lua/plugins")
return M
