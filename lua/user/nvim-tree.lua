local status_ok, tree = pcall(require, 'nvim-tree')
if not status_ok then
	print("Couldn't load 'nvim-tree'")
	return
end

tree.setup {
	disable_netrw = true,
	hijack_cursor = true,
	open_on_setup = true,
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
		icons = {
			error   = "",
			warning = "",
			hint    = "",
			info    = "",
		},
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

	remove_keymaps = {
		'[e', ']e',  -- Default diagnostic prev/next
	},

	on_attach = function(bufnr)
		for lhs, rhs in pairs(require('user.settings.keymaps').nvim_tree) do
			vim.keymap.set('n', lhs, rhs, { silent = true, remap = false, buffer = bufnr })
		end
	end,
}

-- Because reload_on_bufenter doesn't work (when defining on_attach?)
vim.api.nvim_create_autocmd('BufEnter', {
	group = vim.api.nvim_create_augroup('NvimTreeAutoRefresh', { clear = true }),
	desc = 'Refresh NvimTree on BufEnter',
	pattern = 'NvimTree*',
	callback = function() require('nvim-tree.api').tree.reload() end,
})
