local peek_ok, peek = pcall(require, 'peek')
if not peek_ok then
	print("Couldn't load peek")
	return
end

-- default config:
peek.setup {
	auto_load = true, -- whether to automatically load preview when entering another markdown buffer
	close_on_bdelete = true, -- close preview window on buffer delete

	syntax = true, -- enable syntax highlighting, affects performance

	theme = 'dark', -- 'dark' or 'light'

	update_on_change = true,

	-- relevant if update_on_change is true
	throttle_at = 200000, -- start throttling when file exceeds this amount of bytes in size
	throttle_time = 'auto', -- minimum amount of time in milliseconds that has to pass before starting new render
}

-- check for i3
vim.fn.system('pidof i3')
local has_i3 = vim.v.shell_error == 0

local function open_command(has_i3)
	local condition = function()
		return not peek.is_open() and vim.bo[vim.api.nvim_get_current_buf()].filetype == 'markdown'
	end

	return has_i3 and function()
		if condition() then
			vim.fn.system('i3-msg split horizontal')
			peek.open()
		end
	end or function()
		if condition() then peek.open() end
	end
end

local function close_command(has_i3)
	return has_i3 and function()
		if peek.is_open() then
			peek.close()
			vim.fn.system('i3-msg move left')
		end
	end or function()
		if peek.is_open() then peek.close() end
	end
end

vim.api.nvim_create_autocmd('FileType', {
	group = vim.api.nvim_create_augroup('PeekCommands', { clear = true }),
	desc = 'Add commands for markdown buffers',
	pattern = 'markdown',
	callback = function(opts)
		vim.api.nvim_buf_create_user_command(opts.buf, 'PeekOpen', open_command(has_i3), {})
		vim.api.nvim_buf_create_user_command(opts.buf, 'PeekClose', close_command(has_i3), {})
	end,
})
