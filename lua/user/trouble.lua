local status_ok, trouble = pcall(require, 'trouble')
if not status_ok then
	print("Couldn't load 'trouble'")
	return
end

trouble.setup {
	padding = true,
	auto_close = false,
	auto_fold = false,
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
