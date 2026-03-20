vim.bo.textwidth = 80
vim.bo.formatoptions = vim.bo.formatoptions .. "tcqln"

--- Hard-wrap lines exceeding textwidth on save, skipping fenced code blocks.
local function wrap_long_lines()
	local tw = vim.bo.textwidth
	if tw == 0 then
		return
	end

	local save = vim.fn.winsaveview()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local in_fence = false

	for i, line in ipairs(lines) do
		if line:match("^```") then
			in_fence = not in_fence
		elseif not in_fence and #line > tw then
			vim.api.nvim_win_set_cursor(0, { i, 0 })
			vim.cmd("normal! gqq")
			-- lines shifted after gq, reload and rescan from same position
			lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
		end
	end

	vim.fn.winrestview(save)
end

vim.api.nvim_create_autocmd("BufWritePre", {
	buffer = 0,
	callback = function()
		wrap_long_lines()
	end,
})
