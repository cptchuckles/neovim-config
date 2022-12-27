local status_ok, blankline = pcall(require, 'indent_blankline')
if not status_ok then
	print("Couldn't load 'indent_blankline'")
	return
end

blankline.setup {
	char = '│',
	show_trailing_blankline_indent = false,
	show_current_context = true,
	space_char_blankline = ' ',
	use_treesitter = true,
}

require('user.settings.keymaps').indent_blankline()
