local status_ok, ts = pcall(require, 'nvim-treesitter.configs')
if not status_ok then
	print("Couldn't load 'nvim-treesitter.configs'")
	return
end

ts.setup {
	ensure_installed = {
		'lua',
		'bash',
		'gdscript',
		'godot_resource',
		'c_sharp',
		'cpp',
		'c',
		'make',
		'cmake',
		'rust',
		'toml',
		'julia',
		'html',
		'javascript',
		'css',
		'scss',
		'markdown',
		'markdown_inline',
		'json',
		'yaml',
		'ruby',
		'latex',
		'regex',
		'vim',
		'perl',
		'sql',
		'scheme',
	},
	sync_installed = false, -- install languages synchronously (applies to above)
	ignore_installed = { "" }, -- list of parsers to ignore installing
	highlight = {
		enable = true, -- false will disable the whole extension
		disable = { "" },
		additional_vim_regex_highlighting = false,
	},
	incremental_selection = {
		enabled = true,
	},
	textobjects = {
		enabled = true,
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
