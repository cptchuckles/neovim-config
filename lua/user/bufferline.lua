local status_ok, bl = pcall(require, 'bufferline')
if not status_ok then
	print("Couldn't load 'bufferline'")
	return
end

vim.keymap.set('n', '[b', function() bl.cycle(-1) end, { silent = true, remap = false })
vim.keymap.set('n', ']b', function() bl.cycle(1) end, { silent = true, remap = false })

bl.setup {
	options = {
		always_show_bufferline = true,
		tab_size               = 18,
		max_name_length        = 18,
		separator_style        = 'padded_slant',
		sort_by                = 'insert_at_end',

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
				hint    = "",
				info    = "",
			}
			return symbols[level] or ""
		end,

		offsets = {
			{ filetype = 'NvimTree',
				text = function()
					return vim.fn.getcwd():gsub(vim.fn.getenv("HOME"), '~')
				end,
				highlight = 'Visual',
				padding = 1,
				separator = false },
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
