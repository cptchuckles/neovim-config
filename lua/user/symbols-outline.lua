local status_ok, outliner = pcall(require, 'symbols-outline')
if not status_ok then
	print("Couldn't load 'symbols-outline'")
	return
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
	symbols = {
		Array         = { icon = "", hl = "TSConstant"    },
		Boolean       = { icon = "", hl = "TSBoolean"     },
		Class         = { icon = "", hl = "TSType"        },
		Constant      = { icon = "", hl = "TSConstant"    },
		Constructor   = { icon = "", hl = "TSConstructor" },
		Enum          = { icon = "", hl = "TSType"        },
		EnumMember    = { icon = "", hl = "TSField"       },
		Event         = { icon = "", hl = "TSType"        },
		Field         = { icon = "", hl = "TSField"       },
		File          = { icon = "", hl = "TSURI"         },
		Function      = { icon = "", hl = "TSFunction"    },
		Interface     = { icon = "", hl = "TSType"        },
		Key           = { icon = "", hl = "TSType"        },
		Method        = { icon = "", hl = "TSMethod"      },
		Module        = { icon = "", hl = "TSNamespace"   },
		Namespace     = { icon = "", hl = "TSNamespace"   },
		Null          = { icon = "ﳠ", hl = "TSType"        },
		Number        = { icon = "", hl = "TSNumber"      },
		Object        = { icon = "", hl = "TSType"        },
		Operator      = { icon = "", hl = "TSOperator"    },
		Package       = { icon = "", hl = "TSNamespace"   },
		Property      = { icon = "", hl = "TSProperty"    },
		String        = { icon = "", hl = "TSString"      },
		Struct        = { icon = "", hl = "TSType"        },
		TypeParameter = { icon = "𝙏", hl = "TSParameter"   },
		Variable      = { icon = "", hl = "TSConstant"    },
	},
}

vim.api.nvim_create_autocmd('FileType', {
	group = vim.api.nvim_create_augroup("SymbolsOutlinerSettings", { clear = true }),
	pattern = 'Outline',
	callback = function(opts)
		vim.wo[vim.fn.bufwinid(opts.buf)].signcolumn = 'no'
	end,
})
