local status_ok, tree = pcall(require, 'nvim-tree')
if not status_ok then
	print("Couldn't load 'nvim-tree'")
	return
end

tree.setup {
	disable_netrw = true,
	hijack_cursor = true,
	reload_on_bufenter = true,
	prefer_startup_root = true,
	hijack_directories = {
		enable = false,
		auto_open = true,
	},
	open_on_tab = false,
	update_focused_file = {
		enable = true,
		update_root = true,
		ignore_list = { 'help' },
	},
	diagnostics = {
		enable = true,
		show_on_dirs = false,
		show_on_open_dirs = false,
		icons = {
			error   = "",
			warning = "",
			hint    = "",
			info    = "",
		},
	},
	git = {
		show_on_dirs = true,
		show_on_open_dirs = false,
	},
	view = {
		side = "left",
		width = "20%",
		adaptive_size = false,
		preserve_window_proportions = true,
		hide_root_folder = true,
	},
	renderer = {
		add_trailing = true,
		group_empty = true,
		full_name = true,
		indent_markers = {
			enable = true,
			inline_arrows = true,
			icons = {
				edge   = "│",
				item   = "├",
				corner = "└",
				none   = " ",
			},
		},
		highlight_git = true,
		icons = {
			show = {
				git = true,
				folder_arrow = false,
			},
			git_placement = "before",
			glyphs = {
				git = {
					unstaged  = "ﰣ",
					staged    = "",
					unmerged  = "",
					renamed   = "➜",
					untracked = "",
					deleted   = "ﯰ",
					ignored   = "﬒",
				},
			},
		},
	},

	on_attach = require('user.settings.keymaps').nvim_tree
}

-- Because reload_on_bufenter doesn't work (when defining on_attach?)
vim.api.nvim_create_autocmd('BufEnter', {
	group = vim.api.nvim_create_augroup('NvimTreeAutoRefresh', { clear = true }),
	desc = 'Refresh NvimTree on BufEnter',
	pattern = 'NvimTree*',
	callback = function() require('nvim-tree.api').tree.reload() end,
})

-- Recipe for opening on startup:
vim.api.nvim_create_autocmd('VimEnter', {
	group = vim.api.nvim_create_augroup('NvimTreeAutoOpen', { clear = true }),
	desc = 'Open nvim-tree on startup',
	callback = function(opts)
		local directory = vim.fn.isdirectory(opts.file) == 1
		if not directory then
			return
		end

		vim.cmd.cd(opts.file)

		require('nvim-tree.api').tree.open()
	end,
})
