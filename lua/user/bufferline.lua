local status_ok, bufferline = pcall(require, 'bufferline')
if not status_ok then
	print("Couldn't load 'bufferline'")
	return
end

local keymaps = require('user.settings.keymaps').bufferline
for lhs, rhs in pairs(keymaps) do
	vim.keymap.set('n', lhs, rhs, { silent = true, remap = false })
end

bufferline.setup {
	options = {
		always_show_bufferline = true,
		tab_size        = 18,
		max_name_length = 18,
		separator_style = 'thin',
		sort_by = 'insert_at_end',

		color_icons              = true,
		show_buffer_icons        = true,
		show_buffer_close_icons  = false,
		show_buffer_default_icon = true,
		buffer_close_icon        = '',
		close_icon               = '',
		modified_icon            = 'ﰣ',
		left_trunc_marker        = 'ﲑ',
		right_trunc_marker       = 'ﲒ',
		indicator = {
			style = 'icon',
			icon = '▌',
		},

		numbers = function(opts)
			return opts.raise(opts.ordinal)
		end,
		name_formatter = function(buf)
			return buf.name
		end,
		diagnostics_indicator = function(count, level)
			local icon = level:match("error") and ":" or ":"
			return icon .. count
		end,

		offsets = {
			{ filetype = 'NvimTree',
				highlight = 'Visual',
				separator = false,
				padding = 0,
				text = function()
					return vim.fn.getcwd():gsub(vim.fn.getenv("HOME"), '~')
				end,
			},
		},

		custom_filter = function(bufnr, bufnrs)
			local filter_type = {
				-- Set each item to true so indexing works
				help     = true,
				nofile   = true,
				qf       = true,
				acwrite  = true,
				terminal = true,
			}
			if filter_type[vim.bo[bufnr].filetype] or filter_type[vim.bo[bufnr].buftype] then
				return false
			elseif vim.fn.isdirectory(vim.fn.bufname(bufnr)) == 1 then
				return false
			else
				return #vim.fn.bufname(bufnr) > 0
			end
		end,
	},
}
