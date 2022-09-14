local status_ok, bufferline = pcall(require, 'bufferline')
if not status_ok then
	print("Couldn't load 'bufferline'")
	return
end

local keymaps = require('user.settings.keymaps').bufferline
for lhs, rhs in pairs(keymaps) do
	vim.keymap.set('n', lhs, rhs, { silent = true, remap = false })
end

local function get_separator_style()
	local term = vim.fn.getenv('TERM')
	if term == vim.NIL then term = 'xterm-256color' end
	if vim.fn.match(term, 'alacritty') == 0 then
		return 'padded_slant'
	end
	return 'slant'
end

bufferline.setup {
	options = {
		always_show_bufferline = true,
		tab_size        = 18,
		max_name_length = 18,
		separator_style = get_separator_style(),
		sort_by = 'insert_at_end',

		color_icons              = true,
		show_buffer_icons        = true,
		show_buffer_close_icons  = false,
		show_buffer_default_icon = true,
		buffer_close_icon        = '',
		close_icon               = '',
		modified_icon            = 'ﰣ',
		left_trunc_marker        = 'ﬞﲑ',
		right_trunc_marker       = 'ﲒ',
		indicator = {
			style = 'underline',
		},

		numbers = function(opts)
			return opts.raise(opts.ordinal)
		end,
		name_formatter = function(buf)
			return buf.name
		end,
		diagnostic_indicator = function(count, level)
			local symbols = {
				error   = "",
				warning = "",
				hint    = nil,
				info    = "",
			}
			if count > 0 and symbols[level] then
				return symbols[level] .. count
			end
			return ""
		end,

		offsets = {
			{ filetype = 'NvimTree',
				highlight = 'Visual',
				separator = false,
				padding = 1,
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
				return vim.fn.bufname(bufnr) ~= ''
			end
		end,
	},
}
