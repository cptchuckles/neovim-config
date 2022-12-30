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
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				['af'] = { query = '@function.outer', desc = 'Select outer function' },
				['if'] = { query = '@function.inner', desc = 'Select inner function' },
				['ac'] = { query = '@class.outer', desc = 'Select outer class' },
				['ic'] = { query = '@class.inner', desc = 'Select inner class' },
			},
			selection_modes = {
				['@parameter.outer'] = 'v', -- charwise
				['@function.outer'] = 'V', -- linewise
				['@class.outer'] = '<c-v>', -- blockwise
			},
			include_surrounding_whitespace = false,
		},
		swap = {
			enable = true,
			swap_next = {
				['<leader>a'] = '@parameter.inner',
			},
			swap_previous = {
				['<leader>A'] = '@parameter.inner',
			},
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["]m"] = "@function.outer",
				["]]"] = { query = "@class.outer", desc = "Next class start" },
			},
			goto_next_end = {
				["]M"] = "@function.outer",
				["]["] = "@class.outer",
			},
			goto_previous_start = {
				["[m"] = "@function.outer",
				["[["] = "@class.outer",
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
				["[]"] = "@class.outer",
			},
		},
	},

	indent = {
		enable = true,
		-- disable = { "yaml" },
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
	callback = function()
		vim.api.nvim_command [[TSToggle rainbow]]
		vim.api.nvim_command [[TSToggle rainbow]]
	end,
})
