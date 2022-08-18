local status_ok, gitsigns = pcall(require, 'gitsigns')
if not status_ok then
	print("Couldn't load Gitsigns")
	return
end

gitsigns.setup {
	numhl = true,
	current_line_blame = true,
	current_line_blame_opts = {
		delay = 200,
		ignore_whitespace = true,
	},
	current_line_blame_formatter = "  <author>, <author_time> - (<abbrev_sha>) <summary>",
	preview_config = { style = 'minimal', border = 'rounded' },

	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns

		local function map(mode, shortcut, action, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, shortcut, action, opts)
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

		-- Actions
		map({'n', 'v'}, '<leader>gs', ':Gitsigns stage_hunk<CR>')
		map({'n', 'v'}, '<leader>gr', ':Gitsigns reset_hunk<CR>')
		map('n', '<leader>gS', gs.stage_buffer)
		map('n', '<leader>gu', gs.undo_stage_hunk)
		map('n', '<leader>gR', gs.reset_buffer)
		map('n', '<leader>gp', gs.preview_hunk)
		map('n', '<leader>gb', function() gs.blame_line{full=true} end)
		map('n', '<leader>gB', gs.toggle_current_line_blame)
		map('n', '<leader>gd', gs.diffthis)
		map('n', '<leader>gD', function() gs.diffthis('~') end)
		map('n', '<leader>gX', gs.toggle_deleted)
		-- text object
		map({'o', 'x'}, 'ic', ':<C-U>Gitsigns select_hunk<CR>')
	end,
}
