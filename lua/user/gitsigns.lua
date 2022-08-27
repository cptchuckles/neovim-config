local status_ok, gitsigns = pcall(require, 'gitsigns')
if not status_ok then
	print("Couldn't load 'gitsigns'")
	return
end

gitsigns.setup {
	numhl = true,
	current_line_blame = true,
	current_line_blame_opts = {
		delay = 200,
		ignore_whitespace = true,
	},
	current_line_blame_formatter = "⋮  <author>, <author_time> - (<abbrev_sha>) <summary>",
	preview_config = { style = 'minimal', border = 'rounded' },

	signs = {
		add          = {hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'    },
		change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn' },
		delete       = {hl = 'GitSignsDelete', text = '▁', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn' },
		topdelete    = {hl = 'GitSignsDelete', text = '▔', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn' },
		changedelete = {hl = 'GitSignsChange', text = '┊', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn' },
	},

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
		local function reload_nvim_tree_after(f, opts)
			return function()
				if type(f) == "function" then
					f(opts or {})
				elseif type(f) == "string" then
					vim.api.nvim_command(f)
				end
				vim.schedule(vim.F.nil_wrap(function() require('nvim-tree.api').tree.reload() end))
			end
		end
		map({'n', 'v'}, '<leader>gs', reload_nvim_tree_after('Gitsigns stage_hunk'))
		map({'n', 'v'}, '<leader>gr', reload_nvim_tree_after('Gitsigns reset_hunk'))
		map('n', '<leader>gS', reload_nvim_tree_after(gs.stage_buffer))
		map('n', '<leader>gu', reload_nvim_tree_after(gs.undo_stage_hunk))
		map('n', '<leader>gR', reload_nvim_tree_after(gs.reset_buffer))
		-- passive actions
		map('n', '<leader>gb', function() gs.blame_line {full=true, ignore_whitespace=true} end)
		map('n', '<leader>gB', gs.toggle_current_line_blame)
		map('n', '<leader>gp', gs.preview_hunk)
		map('n', '<leader>gd', gs.diffthis)
		map('n', '<leader>gD', function() gs.diffthis('~') end)
		map('n', '<leader>gX', gs.toggle_deleted)
		-- text object
		map({'o', 'x'}, 'ic', ':<C-U>Gitsigns select_hunk<CR>')
	end,
}
