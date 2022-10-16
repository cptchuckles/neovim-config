local status_ok, illuminate = pcall(require, 'illuminate')
if not status_ok then
	print("Couldn't load 'illuminate'")
	return
end

illuminate.configure {
	-- providers: provider used to get references in the buffer, ordered by priority
	providers = {
		'lsp',
		'treesitter',
		'regex',
	},
	-- delay: delay in milliseconds
	delay = 100,
	-- filetype_overrides: filetype specific overrides.
	-- The keys are strings to represent the filetype while the values are tables that
	-- supports the same keys passed to .configure except for filetypes_denylist and filetypes_allowlist
	filetype_overrides = {
		javascript = {
			providers = { 'regex' },
		},
		gdscript = {  -- lsp unsupported, and treesitter doesn't work (vim-illuminate#133)
			providers = { 'regex' },
		},
		sh = {  -- lsp and treesitter are ass (don't match function refs to defs, can't find next)
			providers = { 'regex' },
		},
	},
	-- filetypes_denylist: filetypes to not illuminate, this overrides filetypes_allowlist
	filetypes_denylist = {
		'dirvish',
		'fugitive',
		'NvimTree',
	},
	-- filetypes_allowlist: filetypes to illuminate, this is overriden by filetypes_denylist
	filetypes_allowlist = {},
	-- modes_denylist: modes to not illuminate, this overrides modes_allowlist
	modes_denylist = {},
	-- modes_allowlist: modes to illuminate, this is overriden by modes_denylist
	modes_allowlist = {},
	-- providers_regex_syntax_denylist: syntax to not illuminate, this overrides providers_regex_syntax_allowlist
	-- Only applies to the 'regex' provider
	-- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
	providers_regex_syntax_denylist = {},
	-- providers_regex_syntax_allowlist: syntax to illuminate, this is overriden by providers_regex_syntax_denylist
	-- Only applies to the 'regex' provider
	-- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
	providers_regex_syntax_allowlist = {},
	-- under_cursor: whether or not to illuminate under the cursor
	under_cursor = true,
}
