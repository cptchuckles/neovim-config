local M = {}

local lazytrouble = require('lazy').require_on_exported_call('trouble.providers.telescope')

function M.insert(actions)
	return {
		['<C-R>'] = actions.cycle_history_next,
		['<C-r>'] = actions.cycle_history_prev,

		['<A-j>'] = actions.move_selection_next,
		['<A-k>'] = actions.move_selection_previous,

		['<C-e>'] = actions.close,

		['<Down>'] = actions.move_selection_next,
		['<Up>']   = actions.move_selection_previous,

		['<CR>'] = actions.select_default,
		['<C-x>'] = actions.select_horizontal,
		['<C-v>'] = actions.select_vertical,
		['<C-t>'] = actions.select_tab,

		['<C-u>'] = actions.results_scrolling_up,
		['<C-d>'] = actions.results_scrolling_down,

		['<PageUp>']   = actions.preview_scrolling_up,
		['<PageDown>'] = actions.preview_scrolling_down,

		['<Tab>'] = actions.toggle_selection + actions.move_selection_worse,
		['<S-Tab>'] = actions.toggle_selection + actions.move_selection_better,
		['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
		['<A-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
		['<C-T>'] = lazytrouble.open_with_trouble,
		['<C-l>'] = actions.complete_tag,
		['<C-_>'] = actions.which_key,   -- keys from pressing <C-/> (what?)
	}
end

function M.normal(actions)
	return {
		['<esc>'] = actions.close,
		['<C-x>'] = actions.select_horizontal,
		['<C-v>'] = actions.select_vertical,
		['<C-t>'] = actions.select_tab,

		['<Tab>'] = actions.toggle_selection + actions.move_selection_worse,
		['<S-Tab>'] = actions.toggle_selection + actions.move_selection_better,
		['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
		['<A-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
		['<C-T>'] = lazytrouble.open_with_trouble,

		['<Down>'] = actions.move_selection_next,
		['<Up>']   = actions.move_selection_previous,
		['j'] = actions.move_selection_next,
		['k'] = actions.move_selection_previous,
		['g'] = actions.move_to_top,
		['z'] = actions.move_to_middle,
		['G'] = actions.move_to_bottom,

		['<PageUp>']   = actions.preview_scrolling_up,
		['<PageDown>'] = actions.preview_scrolling_down,

		['?'] = actions.which_key,
	}
end

return M
