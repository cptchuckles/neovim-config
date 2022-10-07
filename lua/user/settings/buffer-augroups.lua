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
	vim.api.nvim_create_autocmd({ 'BufLeave', 'BufHidden' }, {
		group = aug_wipe_buffers,
		desc = 'Delete [No Name] and [Scratch] buffers upon leaving',
		pattern = { '[No Name]', '[Scratch]' },
		callback = function(opts)
			vim.schedule(vim.F.nil_wrap(function() vim.api.nvim_buf_delete(opts.buf) end))
		end,
	})
	vim.api.nvim_create_autocmd('BufHidden', {
		group = aug_wipe_buffers,
		desc = 'Wipeout term:// buffers when hidden',
		pattern = 'term://*',
		callback = function(opts)
			vim.schedule(vim.F.nil_wrap(function() vim.api.nvim_command("bwipeout! " .. opts.buf) end))
		end,
	})
	vim.api.nvim_create_autocmd('WinLeave', {
		group = aug_wipe_buffers,
		desc = 'Wipeout lazygit buffers when accidentally window-switching away',
		pattern = 'term://*:lazygit',
		callback = function(opts)
			vim.schedule(vim.F.nil_wrap(function() vim.api.nvim_command("bwipeout! " .. opts.buf) end))
		end,
	})
	vim.api.nvim_create_autocmd('VimEnter', {
		group = aug_wipe_buffers,
		desc = 'Wipe directory buffers on startup',
		pattern = '*',
		callback = function(opts)
			if vim.fn.isdirectory(vim.fn.bufname(opts.buf)) == 1 then
				vim.schedule(vim.F.nil_wrap(function() vim.api.nvim_command("bwipeout! " .. opts.buf) end))
			end
		end,
	})
end

local function easy_close_window()
	local aug_easy_close = vim.api.nvim_create_augroup('EasyCloseWindowKeybind', { clear = true })
	vim.api.nvim_create_autocmd('FileType', {
		group = aug_easy_close,
		desc = 'Keybind to easily close help and qflist buffer windows',
		pattern = { 'help', 'qf' },
		callback = function(opts)
			local close_func = function()
				vim.api.nvim_win_close(vim.fn.bufwinid(opts.buf), { force = true })
			end
			vim.keymap.set('n', 'q',     close_func, { silent = true, remap = false, buffer = opts.buf })
			vim.keymap.set('n', '<C-q>', close_func, { silent = true, remap = false, buffer = opts.buf })
		end,
	})
	vim.api.nvim_create_autocmd('BufAdd', {
		group = aug_easy_close,
		desc = 'Keybind to easily close git diff windows',
		pattern = { 'gitsigns://*' },
		callback = function(opts)
			vim.keymap.set('n', '<C-q>', function()
				vim.api.nvim_win_close(vim.fn.bufwinid(opts.buf), { force = true })
			end, { silent = true, remap = false, buffer = opts.buf })
		end,
	})
end

local function fold_settings()
	local json_yaml_folding = vim.api.nvim_create_augroup('JsonYamlFoldingSettings', { clear = true })
	vim.api.nvim_create_autocmd('BufAdd', {
		group = json_yaml_folding,
		desc = 'Set indent-based folding at level 2 for json and yaml files',
		pattern = { '*.json', '*.yaml', '*.yml' },
		callback = function(opts)
			vim.schedule(function()
				local wid = vim.fn.bufwinid(opts.buf)
				vim.wo[wid].foldmethod = 'indent'
				vim.wo[wid].foldlevel = 2
			end)
		end,
	})
	vim.api.nvim_create_autocmd('BufHidden', {
		group = json_yaml_folding,
		desc = 'Reset folding method to manual when json/yaml buffers are hidden',
		pattern = { '*.json', '*.yaml', '*.yml' },
		callback = function(opts)
			vim.schedule(function()
				vim.wo[vim.fn.bufwinid('%')].foldmethod = 'manual'
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

local function file_settings()
	local aug_file_settings = vim.api.nvim_create_augroup('UserFileSettings', { clear = true })
	vim.api.nvim_create_autocmd('FileType', {
		group = aug_file_settings,
		desc = 'Enable text wrapping for the specified filetypes',
		pattern = { 'markdown', },
		callback = function(opts)
			vim.opt_local.textwidth = 100
			vim.opt_local.formatoptions:remove('l')
		end,
	})
end

M.setup = function()
	buffer_wiping()
	easy_close_window()
	fold_settings()
	terminal_settings()
	file_settings()
end

return M
