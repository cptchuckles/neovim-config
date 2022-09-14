return function(bufnr)
	local gs = package.loaded.gitsigns

	local function map(mode, lhs, rhs, opts)
		opts = opts or {}
		opts = vim.tbl_extend('force', opts, { buffer = bufnr })
		vim.keymap.set(mode, lhs, rhs, opts)
	end

	-- Navigation
	map('n', ']c', function()
		if vim.wo.diff then return ']c' end
		vim.schedule(function() gs.next_hunk() end)
		return '<Ignore>'
	end, { expr = true })

	map('n', '[c', function()
		if vim.wo.diff then return '[c' end
		vim.schedule(function() gs.prev_hunk() end)
		return '<Ignore>'
	end, { expr = true })

	--- Get a callback to bind to a keymap that runs the given function or command
	--- and then schedules a safe call to `nvim-tree.api.tree.reload`
	---@param cmd string | fun() Function or command to run
	---@return fun()
	local function reload_nvim_tree_after(cmd)
		return function()
			if type(cmd) == "function" then
				cmd()
			elseif type(cmd) == "string" then
				local keys = vim.api.nvim_replace_termcodes(cmd, true, false, true)
				vim.api.nvim_feedkeys(keys, 'n', false)
			end
			vim.schedule(vim.F.nil_wrap(function() require('nvim-tree.api').tree.reload() end))
		end
	end

	-- Actions
	map({ 'n', 'v' }, '<leader>gs', reload_nvim_tree_after [[:Gitsigns stage_hunk<CR>]])
	map({ 'n', 'v' }, '<leader>gr', reload_nvim_tree_after [[:Gitsigns reset_hunk<CR>]])
	map('n', '<leader>gS', reload_nvim_tree_after(gs.stage_buffer))
	map('n', '<leader>gu', reload_nvim_tree_after(gs.undo_stage_hunk))
	map('n', '<leader>gR', reload_nvim_tree_after(gs.reset_buffer))
	-- passive actions
	map('n', '<leader>gb', function() gs.blame_line { full = true, ignore_whitespace = true } end)
	map('n', '<leader>gB', gs.toggle_current_line_blame)
	map('n', '<leader>gp', gs.preview_hunk)
	map('n', '<leader>gd', gs.diffthis)
	map('n', '<leader>gD', function() gs.diffthis('~') end)
	map('n', '<leader>gX', gs.toggle_deleted)
	-- text object
	map({ 'o', 'x' }, 'ic', [[<Cmd>Gitsigns select_hunk<CR>]])
end
