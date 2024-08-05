local utils = {}

function utils.compile_and_run_file(file_type, file_name)
	local run_command_table = {
		py = "python3",
		js = "node",
		ts = "ts-node",
		hs = "/Users/kyle/.ghcup/bin/stack build; /Users/kyle/.ghcup/bin/stack test",
		lua = "/opt/homebrew/bin/lua",
	}
	return run_command_table[file_type] .. " " .. file_name
end

function utils.compile_and_run_tests(file_type, file_name)
	local test_command_table = {
		py = "python3",
		js = "node",
		ts = "ts-node",
		hs = "/Users/kyle/.ghcup/bin/stack build; /Users/kyle/.ghcup/bin/stack test",
		lua = "/opt/homebrew/bin/lua",
	}
	--haskell is special and stack doesn't need the file name since it runs thwhole test suite.
	-- probably have to add this for more things later like pytest, etc.
	if file_type == "hs" then
		return test_command_table[file_type]
	else
		return test_command_table[file_type] .. " " .. file_name
	end
end

function utils.get_filetype_command(filetype)
	local command_table = {
		py = "python3",
		js = "node",
		ts = "ts-node",
		hs = "/Users/kyle/.ghcup/bin/stack build; /Users/kyle/.ghcup/bin/stack test",
		lua = "/opt/homebrew/bin/lua",
	}
	local command = command_table[filetype]
	return command
end

function utils.get_file_name(tab_title)
	-- Match the initial part of the filename before the first dot
	return tab_title:match("([^%.]+)")
end

function utils.get_file_type(tab_title)
	return tab_title:match("^.+%.(.+)$")
end

function utils.detect_host_os()
	-- package.config:sub(1,1) returns '\' for windows and '/' for *nix.
	if package.config:sub(1, 1) == "\\" then
		return "windows"
	else
		-- uname should be available on *nix systems.
		local check = io.popen("uname -s")
		if check ~= nil then
			local result = check:read("*l")
			check:close()
			if result == "Darwin" then
				return "macos"
			else
				return "linux"
			end
		end
	end
end

return utils
