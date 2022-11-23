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
		Array         = { icon = "", hl = "@constant"    },
		Boolean       = { icon = "", hl = "@boolean"     },
		Class         = { icon = "", hl = "@type"        },
		Constant      = { icon = "", hl = "@constant"    },
		Constructor   = { icon = "", hl = "@constructor" },
		Enum          = { icon = "", hl = "@type"        },
		EnumMember    = { icon = "", hl = "@field"       },
		Event         = { icon = "", hl = "@type"        },
		Field         = { icon = "", hl = "@field"       },
		File          = { icon = "", hl = "@uRI"         },
		Function      = { icon = "", hl = "@function"    },
		Interface     = { icon = "", hl = "@type"        },
		Key           = { icon = "", hl = "@type"        },
		Method        = { icon = "", hl = "@method"      },
		Module        = { icon = "", hl = "@namespace"   },
		Namespace     = { icon = "", hl = "@namespace"   },
		Null          = { icon = "ﳠ", hl = "@type"        },
		Number        = { icon = "", hl = "@number"      },
		Object        = { icon = "", hl = "@type"        },
		Operator      = { icon = "", hl = "@operator"    },
		Package       = { icon = "", hl = "@namespace"   },
		Property      = { icon = "", hl = "@property"    },
		String        = { icon = "", hl = "@string"      },
		Struct        = { icon = "", hl = "@type"        },
		TypeParameter = { icon = "𝙏", hl = "@parameter"   },
		Variable      = { icon = "", hl = "@constant"    },
	},
}

vim.api.nvim_create_autocmd('FileType', {
	group = vim.api.nvim_create_augroup("SymbolsOutlinerSettings", { clear = true }),
	pattern = 'Outline',
	callback = function(opts)
		vim.wo[vim.fn.bufwinid(opts.buf)].signcolumn = 'no'
	end,
})
