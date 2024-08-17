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

	keys = {
		["<cr>"] = "jump",
		["<tab>"] = "preview",
		W = "fold_close_recursive",
		E = "fold_open_recursive",
		h = "fold_toggle",
		l = "fold_toggle",
	},

	signs = {
		error       = "",
		warning     = "",
		hint        = "ﯧ",
		information = "",
		other       = '◊',
	},
}
