local utils = {}

function utils.compile_and_run_file(file_type, file_name)
	local run_command_table = {
		py = "python3",
		js = "node",
		ts = "ts-node",
		hs = "stack build; stack test",
		lua = "lua",
	}
	return run_command_table[file_type] .. " " .. file_name
end

function utils.compile_and_run_tests(file_type, file_name)
	local test_command_table = {
		py = "python3",
		js = "node",
		ts = "ts-node",
		hs = "stack build; stack test",
		lua = "lua",
	}
	--haskell is special and stack doesn't need the file name since it runs thwhole test suite.
	-- probably have to add this for more things later like pytest, etc.
	if file_type == "hs" then
		return test_command_table[file_type]
	else
		return test_command_table[file_type] .. " " .. file_name
	end
end

function utils.get_file_type(tab_title)
	return tab_title:match("^.+%.(.+)$")
end

return utils
