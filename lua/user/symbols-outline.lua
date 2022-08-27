local status_ok, outliner = pcall(require, 'symbols-outline')
if not status_ok then
	print("Couldn't load 'symbols-outline'")
	return
end

outliner.setup {
	highlight_hovered_item = true,
	show_guides = true,
	auto_preview = false,  -- Doesn't jump buffer to location, opens popup window.
	position = 'right',
	relative_width = true,
	width = 25,
	auto_close = false,
	show_numbers = false,
	show_relative_numbers = false,
	show_symbol_details = true,
	preview_bg_highlight = 'Pmenu',
	autofold_depth = nil,
	auto_unfold_hover = true,
	fold_markers = { '', '' },
	keymaps = {  -- These keymaps can be a string or a table for multiple keys
		close          = {"<Esc>", "q"},
		goto_location  = "<CR>",
		focus_location = "<Tab>",
		hover_symbol   = "<Space>",
		toggle_preview = "K",
		rename_symbol  = "r",
		code_actions   = "a",
		fold           = "h",
		unfold         = "l",
		fold_all       = "W",
		unfold_all     = "E",
		fold_reset     = "R",
	},
	lsp_blacklist = {},
	symbol_blacklist = {},
	symbols = {
		Array         = {icon = "", hl = "TSConstant"},
		Boolean       = {icon = "", hl = "TSBoolean"},
		Class         = {icon = "", hl = "TSType"},
		Constant      = {icon = "", hl = "TSConstant"},
		Constructor   = {icon = "", hl = "TSConstructor"},
		Enum          = {icon = "", hl = "TSType"},
		EnumMember    = {icon = "", hl = "TSField"},
		Event         = {icon = "", hl = "TSType"},
		Field         = {icon = "", hl = "TSField"},
		File          = {icon = "", hl = "TSURI"},
		Function      = {icon = "", hl = "TSFunction"},
		Interface     = {icon = "", hl = "TSType"},
		Key           = {icon = "", hl = "TSType"},
		Method        = {icon = "", hl = "TSMethod"},
		Module        = {icon = "", hl = "TSNamespace"},
		Namespace     = {icon = "", hl = "TSNamespace"},
		Null          = {icon = "NULL", hl = "TSType"},
		Number        = {icon = "", hl = "TSNumber"},
		Object        = {icon = "", hl = "TSType"},
		Operator      = {icon = "", hl = "TSOperator"},
		Package       = {icon = "", hl = "TSNamespace"},
		Property      = {icon = "", hl = "TSProperty"},
		String        = {icon = "", hl = "TSString"},
		Struct        = {icon = "", hl = "TSType"},
		TypeParameter = {icon = "𝙏", hl = "TSParameter"},
		Variable      = {icon = "", hl = "TSConstant"},
	},
}

vim.cmd [[
	augroup SymbolsOutlinerSettings
		au!
		au FileType Outline setl signcolumn=no
	augroup end
]]
