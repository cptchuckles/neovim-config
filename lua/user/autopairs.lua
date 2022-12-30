local status_ok, autopairs = pcall(require, 'nvim-autopairs')
if not status_ok then
	print("Couldn't load 'nvim-autopairs'")
	return
end

autopairs.setup {
	disable_filetype = { "TelescopePrompt" },
	disable_in_macro = false,
	disable_in_visualblock = false,
	disable_in_replace_mode = true,
	ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
	enable_moveright = true,
	enable_afterquote = true,
	enable_check_bracket_line = true,
	enable_bracket_in_quote = true,
	enable_abbr = false,
	break_undo = true,
	check_ts = false,
	map_cr = true,
	map_bs = true,
	map_c_h = false,
	map_c_w = true,
}

local cmp_ok, cmp = pcall(require, 'cmp')
if cmp_ok then
	cmp.event:on(
		'confirm_done',
		require('nvim-autopairs.completion.cmp').on_confirm_done()
	)
end
