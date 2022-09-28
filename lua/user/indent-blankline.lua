local status_ok, blankline = pcall(require, 'indent_blankline')
if not status_ok then
	print("Couldn't load 'indent_blankline'")
	return
end

blankline.setup {
	char = '│',
	show_trailing_blankline_indent = false,
	show_cursor_context_start = true,
	space_char_blankline = ' ',
}

-- Folds
local zmaps = {
	'zA', 'zC', 'zD', 'zE', 'zM', 'zN', 'zO', 'zR',
	'za', 'zc', 'zd', 'zi', 'zm', 'zn', 'zo', 'zr', 'zv', 'zx',
}
for _, lhs in ipairs(zmaps) do
	vim.keymap.set('n', lhs, function()
		vim.api.nvim_feedkeys(lhs, 'n', false)
		vim.schedule(vim.F.nil_wrap(function() require('indent_blankline').refresh() end))
	end, { remap = false, silent = true })
end
