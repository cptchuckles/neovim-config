local cmp_status_ok, cmp = pcall(require, 'cmp')
if not cmp_status_ok then
	return
end

local snip_status_ok, luasnip = pcall(require, 'luasnip')
if not snip_status_ok then
	return
end

require("luasnip/loaders/from_vscode").lazy_load()

local check_backspace = function()
	local col = vim.fn.col '.' - 1
	return col == 0 or vim.fn.getline('.'):sub(col, col):match "%s"
end

local kind_icons = {
	Text = '',
	Method = '',
	Function = '',
	Constructor = '',
	Field = '',
	Variable = '',
	Class = '',
	Interface = '',
	Module = '',
	Property = '',
	Unit = '',
	Value = '',
	Enum = '',
	Keyword = 'ﴰ',
	Snippet = '',
	Color = '',
	File = '',
	Reference = '',
	Folder = '',
	EnumMember = '',
	Constant = '',
	Struct = '',
	Event = '',
	Operator = '',
	TypeParameter = '',
}
-- find more at https://www.nerdfonts.com/cheat-sheet

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},

	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},

	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),

		-- Accept currently selected item.
		-- Set `select` to `false` to only confirm explicitly selected items.
		['<CR>'] = cmp.mapping.confirm({ select = true }),

		-- Supertab
		['<Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expandable() then
				luasnip.expand()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif check_backspace() then
				fallback()
			else
				fallback()
			end
		end, {'i', 's'}),
		['<S-Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, {'i', 's'}),
	}),

	formatting = {
		fields = { 'kind', 'abbr', 'menu' },
		format = function(entry, vim_item)
			-- Kind icons
			vim_item.kind = string.format("%s", kind_icons[vim_item.kind])

			vim_item.menu = ({
				luasnip = '[LuaSnip]',
				buffer = '[Buffer]',
				path = '[Path]',
			})[entry.source.name]

			return vim_item
		end,
	},

	sources = {
		{ name = 'buffer' },
		{ name = 'luasnip' },
		{ name = 'path' },
	},

	confirm_opts = {
		behavior = cmp.ConfirmBehavior.Replace,
		select = false,
	},

	window = {
		documentation = cmp.config.window.bordered(),
	},

	experimental = {
		ghost_text = true,
		native_menu = false,
	},
})

cmp.setup.cmdline('/', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' },
	},
})

cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'path' }
	}, {
		{ name = 'cmdline' }
	}),
})


