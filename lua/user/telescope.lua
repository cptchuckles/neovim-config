local status_ok, telescope = pcall(require, 'telescope')
if not status_ok then
	print("Couldn't load 'telescope'")
	return
end

local actions = require 'telescope.actions'

telescope.setup {
	defaults = {
		prompt_prefix = ' ',
		selection_caret = ' ',
		sorting_strategy = 'ascending',
		path_display = function(opts, path)
			local U = require('telescope.utils')
			local tail = U.path_tail(path)
			local short = U.transform_path({path_display={shorten=2}}, path)
			return string.format("%s (%s)", tail, short)
		end,

		layout_config = {
			horizontal = {
				width = 0.9,
			},
		},

		mappings = {
			i = {
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

				['<PageUp>'] = actions.preview_scrolling_up,
				['<PageDown>'] = actions.preview_scrolling_down,

				['<Tab>'] = actions.toggle_selection + actions.move_selection_worse,
				['<S-Tab>'] = actions.toggle_selection + actions.move_selection_better,
				['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
				['<A-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
				['<C-l>'] = actions.complete_tag,
				['<C-_>'] = actions.which_key,   -- keys from pressing <C-/> (what?)
			},

			n = {
				['<esc>'] = actions.close,
				['<C-x>'] = actions.select_horizontal,
				['<C-v>'] = actions.select_vertical,
				['<C-t>'] = actions.select_tab,

				['<Tab>'] = actions.toggle_selection + actions.move_selection_worse,
				['<S-Tab>'] = actions.toggle_selection + actions.move_selection_better,
				['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
				['<A-q>'] = actions.send_selected_to_qflist + actions.open_qflist,

				['<Down>'] = actions.move_selection_next,
				['<Up>']   = actions.move_selection_previous,
				['j'] = actions.move_selection_next,
				['k'] = actions.move_selection_previous,
				['g'] = actions.move_to_top,
				['z'] = actions.move_to_middle,
				['G'] = actions.move_to_bottom,

				['<PageUp>'] = actions.preview_scrolling_up,
				['<PageDown>'] = actions.preview_scrolling_down,

				['?'] = actions.which_key,
			},
		},

		pickers = {
			-- Default configuration for builtin pickers goes here
			-- picker_name = {
			--	picker_config_key = value,
			--	...
			-- },
			-- Now the picker config key will be applied each time you call this
			-- builtin picker
		},

		extensions = {
			-- Your extension configuration goes here:
			-- please look at the readme of the extension you want to configure
		},
	},
}
