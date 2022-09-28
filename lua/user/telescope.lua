local status_ok, telescope = pcall(require, 'telescope')
if not status_ok then
	print("Couldn't load 'telescope'")
	return
end

local keys = require('user.settings.keymaps').telescope
local actions = require('telescope.actions')

telescope.setup {
	defaults = {
		winblend = 10,
		prompt_prefix = ' ',
		selection_caret = ' ',
		sorting_strategy = 'ascending',

		layout_strategy = 'flex',

		layout_config = {
			horizontal = {
				width = 0.9,
				preview_width = 0.5,
			},
			center = {
				width = 0.7,          -- TODO: bug report this not working
				preview_cutoff = 40,  -- lines
			},
			flex = {
				flip_columns = 120,
				flip_lines = 1,
			},
		},

		mappings = {
			n = keys.normal(actions),
			i = keys.insert(actions),
		},
	},

	pickers = {
		lsp_references = {
			require('telescope.themes').get_dropdown(),
			show_line = false,
		},
	},

	extensions = {
		['ui-select'] = {
			require('telescope.themes').get_cursor(),
		},
	},
}

telescope.load_extension('ui-select')
