local M = {}

local function buffer_wiping()
	local aug_wipe_buffers = vim.api.nvim_create_augroup('WipeUnwantedBuffers', { clear = true })
	vim.api.nvim_create_autocmd('FileType', {
		group = aug_wipe_buffers,
		desc = 'Wipe buffers and remove colorcolumn for certain kinds of buffers',
		pattern = { 'Trouble', 'netrw', 'qf', 'nofile' },
		callback = function(opts)
			if opts.match ~= 'Trouble' then
				vim.bo[opts.buf].bufhidden = 'wipe'
			end
			vim.wo[vim.fn.bufwinid(opts.buf)].colorcolumn = '' -- No colorcolumn on these buffers
		end,
	})
	vim.api.nvim_create_autocmd('BufLeave', {
		group = aug_wipe_buffers,
		desc = 'Delete [No Name] buffers upon leaving',
		pattern = '[No Name]',
		callback = function(opts)
			vim.api.nvim_buf_delete(opts.buf)
		end,
	})
end

local function fold_settings()
	vim.api.nvim_create_autocmd('FileType', {
		group = vim.api.nvim_create_augroup('JsonYamlFoldingSettings', { clear = true }),
		desc = 'Set indent-based folding at level 2 for json and yaml files',
		pattern = { 'json', 'yaml' },
		callback = function(opts)
			vim.schedule(function()
				local wid = vim.fn.bufwinid(opts.buf)
				vim.wo[wid].foldmethod = 'indent'
				vim.wo[wid].foldlevel = 2
			end)
		end,
	})
end

local function terminal_settings()
	local aug_terminal_settings = vim.api.nvim_create_augroup('TerminalSettings', { clear = true })
	vim.api.nvim_create_autocmd('TermOpen', {
		group = aug_terminal_settings,
		desc = 'Set some nice defaults for opening a terminal buffer',
		pattern = '*',
		callback = function(opts)
			local wid = vim.fn.bufwinid(opts.buf)
			vim.wo[wid].number          = false
			vim.wo[wid].relativenumber  = false
			vim.wo[wid].cursorline      = false
			vim.wo[wid].list            = false
			vim.bo[opts.buf].modifiable = true
			vim.api.nvim_command [[startinsert]]
		end,
	})
	vim.api.nvim_create_autocmd('BufEnter', {
		group = aug_terminal_settings,
		desc = 'Enter insert mode automatically when entering a terminal buffer',
		pattern = 'term://*',
		command = 'startinsert',
	})
end

M.setup = function()
	buffer_wiping()
	fold_settings()
	terminal_settings()
end

return M
