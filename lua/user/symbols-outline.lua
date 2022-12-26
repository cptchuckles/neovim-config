local status_ok, outliner = pcall(require, 'symbols-outline')
if not status_ok then
	print("Couldn't load 'symbols-outline'")
	return
end

local symbols = {
	Array         = { hl = "@constant" },
	Boolean       = { hl = "@boolean" },
	Class         = { hl = "@type" },
	Constant      = { hl = "@constant" },
	Constructor   = { hl = "@constructor" },
	Enum          = { hl = "@type" },
	EnumMember    = { hl = "@field" },
	Event         = { hl = "@type" },
	Field         = { hl = "@field" },
	File          = { hl = "@uRI" },
	Function      = { hl = "@function" },
	Interface     = { hl = "@type" },
	Key           = { hl = "@type" },
	Method        = { hl = "@method" },
	Module        = { hl = "@namespace" },
	Namespace     = { hl = "@namespace" },
	Null          = { hl = "@type" },
	Number        = { hl = "@number" },
	Object        = { hl = "@type" },
	Operator      = { hl = "@operator" },
	Package       = { hl = "@namespace" },
	Property      = { hl = "@property" },
	String        = { hl = "@string" },
	Struct        = { hl = "@type" },
	TypeParameter = { hl = "@parameter" },
	Variable      = { hl = "@constant" },
}

local user_icons = require('user.settings.icons')
for key, value in pairs(symbols) do
	symbols[key] = vim.tbl_extend("force", value, { icon = user_icons[key] })
end

outliner.setup {
	highlight_hovered_item = true,
	show_guides = true,
	auto_preview = false, -- Doesn't jump buffer to location, opens popup window.
	position = 'right',
	relative_width = true,
	width = 20,
	auto_close = false,
	show_numbers = false,
	show_relative_numbers = false,
	show_symbol_details = true,
	preview_bg_highlight = 'Pmenu',
	autofold_depth = nil,
	auto_unfold_hover = true,
	fold_markers = { '', '' },
	keymaps = require('user.settings.keymaps').symbols_outline,
	lsp_blacklist = {},
	symbol_blacklist = {},
	symbols = symbols,
}

vim.api.nvim_create_autocmd('FileType', {
	group = vim.api.nvim_create_augroup("SymbolsOutlinerSettings", { clear = true }),
	pattern = 'Outline',
	callback = function(opts)
		vim.wo[vim.fn.bufwinid(opts.buf)].signcolumn = 'no'
	end,
})
