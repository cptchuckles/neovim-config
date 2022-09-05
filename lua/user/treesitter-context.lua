local status_ok, tscontext = pcall(require, 'treesitter-context')
if not status_ok then
	print("Couldn't load 'treesitter-context'")
	return
end

tscontext.setup({
	mode = 'topline',
	-- separator = '─',
	patterns = {
		lua = {
			'variable_declaration',
			'table_constructor',
		},
	},
	exclude_patterns = {  -- This shit isn't fucking working!!!!
		cs = {
			'attribute_list',
			'attribute',
		},
	},
})
