local M = {}

local function buffer_wiping()
	local aug_wipe_buffers = vim.api.nvim_create_augroup('WipeUnwantedBuffers', { clear = true })
	vim.api.nvim_create_autocmd('FileType', {
		group = aug_wipe_buffers,
		desc = 'Wipe buffers and remove colorcolumn for certain kinds of buffers',
		pattern = { 'Trouble', 'netrw', 'qf', 'nofile', '' },
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
	local function close_bufwinid(bufnr)
		return function()
			vim.api.nvim_command [[lclose]]
			local winid = vim.fn.bufwinid(bufnr)
			if winid < 0 then
				return
			end
			vim.api.nvim_command [[wincmd p]]
			vim.api.nvim_win_close(winid, { force = true })
		end
	end
	local function keymap_opts(bufnr)
		return {
			silent = true,
			remap  = false,
			buffer = bufnr,
		}
	end
	vim.api.nvim_create_autocmd('FileType', {
		group = aug_easy_close,
		desc = 'Keybind to easily close special buffer windows',
		pattern = { 'help', 'qf', 'tsplayground' },
		callback = function(opts)
			vim.keymap.set('n', 'q',     close_bufwinid(opts.buf), keymap_opts(opts.buf))
			vim.keymap.set('n', '<C-q>', close_bufwinid(opts.buf), keymap_opts(opts.buf))
		end,
	})
	vim.api.nvim_create_autocmd('BufAdd', {
		group = aug_easy_close,
		desc = 'Keybind to easily close git diff windows',
		pattern = { 'gitsigns://*' },
		callback = function(opts)
			vim.keymap.set('n', '<C-q>', close_bufwinid(opts.buf), keymap_opts(opts.buf))
		end,
	})
end

local function json_yaml_settings()
	local aug_json_yaml = vim.api.nvim_create_augroup('JsonYamlSettings', { clear = true })
	vim.api.nvim_create_autocmd('BufAdd', {
		group = aug_json_yaml,
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
		group = aug_json_yaml,
		desc = 'Reset folding method to manual when json/yaml buffers are hidden',
		pattern = { '*.json', '*.yaml', '*.yml' },
		callback = function(opts)
			vim.schedule(function()
				vim.wo[vim.fn.bufwinid('%')].foldmethod = 'manual'
			end)
		end,
	})

	local function convert_json_to_yaml(opts)
		local flag = opts.reverse and '-j' or '-y'
		local cursor_percent = vim.fn.line('.') / vim.fn.line('$')
		vim.api.nvim_command('silent %!yq ' .. flag)
		vim.bo[opts.bufnr].filetype = opts.reverse and 'json' or 'yaml'
		vim.fn.cursor(math.floor(vim.fn.line('$') * cursor_percent + 0.5), 0)
	end

	vim.api.nvim_create_autocmd('FileType', {
		group = aug_json_yaml,
		desc = 'Map json-to-yaml keybind',
		pattern = 'json',
		callback = function(opts)
			vim.keymap.set('n', '<leader>j', function()
				convert_json_to_yaml { bufnr = opts.buf }
			end, { silent = true, remap = false, buffer = opts.buf })
		end,
	})
	vim.api.nvim_create_autocmd('FileType', {
		group = aug_json_yaml,
		desc = 'Map yaml-to-json keybind',
		pattern = 'yaml',
		callback = function(opts)
			vim.keymap.set('n', '<leader>j', function()
				convert_json_to_yaml { bufnr = opts.buf, reverse = true }
			end, { silent = true, remap = false, buffer = opts.buf })
		end,
	})
	vim.api.nvim_create_autocmd('BufWritePre', {
		group = aug_json_yaml,
		desc = 'Convert *.json files back to json before saving',
		pattern = '*.json',
		callback = function(opts)
			convert_json_to_yaml { bufnr = opts.buf, reverse = true }
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
	vim.api.nvim_create_autocmd('TermClose', {
		group = aug_terminal_settings,
		desc = 'Return to previous window and close the terminal buffer',
		pattern = '*',
		callback = function(opts)
			if vim.endswith(opts.match, "lazygit") then
				-- Let lazygit windows close themselves
				return
			end
			vim.api.nvim_command [[wincmd p]]
			vim.api.nvim_win_close(vim.fn.bufwinid(opts.buf), { force = true })
			vim.api.nvim_command("bdelete! " .. opts.buf)
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
		callback = function()
			vim.opt_local.textwidth = 100
			vim.opt_local.formatoptions:remove('l')
		end,
	})
	vim.api.nvim_create_autocmd('BufWritePre', {
		group = aug_file_settings,
		desc = 'Format HTML/XML using built-in indentation upon save',
		pattern = { '*.html', '*.xml' },
		callback = function()
			vim.api.nvim_feedkeys("gg=G<C-o>", 'n', true)
		end,
	})
end

M.setup = function()
	buffer_wiping()
	easy_close_window()
	json_yaml_settings()
	terminal_settings()
	file_settings()
end

return M
