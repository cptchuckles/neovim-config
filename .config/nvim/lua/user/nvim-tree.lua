local status_ok, tree = pcall(require, 'nvim-tree')
if not status_ok then
	print("nvim-tree couldn't be loaded")
	return
end

tree.setup {
	disable_netrw = true,
	hijack_cursor = true,
	open_on_setup = true,
	reload_on_bufenter = true,
	hijack_directories = {
		enable = false,
		auto_open = true,
	},
	open_on_tab = true,
	update_focused_file = {
		enable = true,
		update_root = true,
	},
	diagnostics = {
		enable = true,
		show_on_dirs = true,
		icons = {
			error = "",
			warning = "",
			hint = "",
			info = "",
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
		full_name = true,
		indent_markers = {
			enable = true,
			inline_arrows = true,
		},
		highlight_git = true,
		icons = {
			show = {
				git = false,
			},
		},
	},

	remove_keymaps = {
		'[e', ']e',  -- Default diagnostic prev/next
		'[c', ']c',  -- Default git prev/next
	},

	on_attach = function(bufnr)
		local ntapi = require('nvim-tree.api')
		local map = function(m, lhs, rhs)
			vim.keymap.set(m, lhs, rhs, { buffer = bufnr, remap = false })
		end

		map('n', '[d', ntapi.node.navigate.diagnostics.prev)
		map('n', ']d', ntapi.node.navigate.diagnostics.next)
		map('n', '[c', ntapi.node.navigate.git.prev)
		map('n', ']c', ntapi.node.navigate.git.next)
	end,
}

-- Because reload_on_bufenter doesn't work (when defining on_attach?)
vim.cmd [[
	augroup NvimTreeAutoRefresh
		au!
		au FileType NvimTree au BufEnter * lua require("nvim-tree.api").tree.reload()
	augroup end
]]
