local status_ok, bl = pcall(require, 'indent_blankline')
if not status_ok then
	print("Couldn't load 'indent_blankline'")
	return
end

bl.setup {
	char = "",
	space_char_highlight_list = {
		"IndentBlanklineIndent1",
		"IndentBlanklineIndent2",
	},
	show_trailing_blankline_indent = false,
	show_cursor_context_start = true,
	space_char_blankline = " ",
}

-- Folds
local zmaps = { "zc", "zC", "zo", "zO", "zr", "zR", "zm", "zM", "zn", "zN", "zd", "zD", "zE", }
for _, zm in ipairs(zmaps) do
	vim.keymap.set("n", zm, zm .. ":lua pcall(function() require('indent_blankline').refresh() end)<CR>",
		{ remap = false, silent = true })
end
