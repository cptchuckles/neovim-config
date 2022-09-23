local status_ok, trouble = pcall(require, 'trouble')
if not status_ok then
	print("Couldn't load 'trouble'")
	return
end

trouble.setup {
	padding = false,

	-- Stop fucking setting this to true because it yeets any list that isn't diagnostics (like references)
	auto_close = false,

	auto_fold = false,
	auto_jump = {
		"lsp_definitions",
		"lsp_references",
	},

	action_keys = {
		jump        = '<cr>',
		preview     = '<tab>',
		close_folds = 'W',
		open_folds  = 'E',
		toggle_fold = { 'h', 'l' },
	},
	signs = {
		error       = "",
		warning     = "",
		hint        = "ﯧ",
		information = "",
		other       = '◊',
	},
}
