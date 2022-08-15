local status_ok, treesitterConfig = pcall(require, 'nvim-treesitter.configs')
if not status_ok then
	print("Unable to get nvim-treesitter.configs")
	return
end

treesitterConfig.setup {
	ensure_installed = "all", -- "all", or a list of language names
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
	context_commentstring {
		enable = true,
		enable_autocmd = false,
	},

	-- third-party plugins
	rainbow = {
		enable = true,
		extended_mode = true,
		max_file_lines = nil,
	},
}
