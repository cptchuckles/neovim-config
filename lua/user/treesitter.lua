local status_ok, ts = pcall(require, 'nvim-treesitter.configs')
if not status_ok then
	print("Couldn't load 'nvim-treesitter.configs'")
	return
end

ts.setup {
	ensure_installed = {
		'bash'      , 'c'   , 'c_sharp', 'cmake' , 'cpp' , 'css' , 'gdscript', 'godot_resource' , 'html',
		'javascript', 'json', 'julia'  , 'latex' , 'lua' , 'make', 'markdown', 'markdown_inline', 'perl',
		'regex'     , 'ruby', 'rust'   , 'scheme', 'scss', 'sql' , 'toml'    , 'vim'            , 'yaml',
	},
	sync_installed = false, -- install languages synchronously (applies to above)
	ignore_installed = { "" }, -- list of parsers to ignore installing
	highlight = {
		enable = true, -- false will disable the whole extension
		additional_vim_regex_highlighting = false,
	},
	incremental_selection = {
		enable = true,
	},
	textobjects = {
		enable = true,
	},
	indent = {
		enable = true,
		disable = { "yaml" },
	},

	-- third-party plugins
	rainbow = {
		enable = true,
		extended_mode = true,
		max_file_lines = nil,
	},
}

vim.api.nvim_command [[ highlight TSComment cterm=italic gui=italic ]]

local context_ok, tscontext = pcall(require, 'treesitter-context')
if not context_ok then
	print("Couldn't load 'treesitter-context'")
	return
end

tscontext.setup {
	mode = 'cursor',
	-- separator = '─',
	patterns = {
		lua = {
			'variable_declaration',
			'table_constructor',
		},
		gdscript = {
			'variable_statement',
			'enum_definition',
		},
	},
	exclude_patterns = {  -- This shit isn't fucking working!!!!
		cs = {
			'attribute_list',
			'attribute',
		},
	},
}
