local status_ok, ts = pcall(require, 'nvim-treesitter.configs')
if not status_ok then
	print("Couldn't load 'nvim-treesitter.configs'")
	return
end

ts.setup {
	ensure_installed = {
		'bash',
		'c',
		'c_sharp',
		'cmake',
		'cpp',
		'css',
		'gdscript',
		'godot_resource',
		'html',
		'javascript',
		'json',
		'julia',
		'latex',
		'lua',
		'make',
		'markdown',
		'markdown_inline',
		'perl',
		'regex',
		'ruby',
		'rust',
		'scheme',
		'scss',
		'sql',
		'toml',
		'vim',
		'yaml',
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

	matchup = {
		enable = true,
	},
}

vim.api.nvim_create_autocmd('BufWritePost', {
	group = vim.api.nvim_create_augroup('TSRainbowRefresh', { clear = true }),
	pattern = '*.*',
	callback = function(opts)
		vim.api.nvim_command [[TSToggle rainbow]]
		vim.api.nvim_command [[TSToggle rainbow]]
	end,
})
