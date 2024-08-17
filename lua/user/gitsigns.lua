local status_ok, gitsigns = pcall(require, 'gitsigns')
if not status_ok then
	print("Couldn't load 'gitsigns'")
	return
end

gitsigns.setup {
	numhl = true,
	current_line_blame = true,
	current_line_blame_opts = {
		delay = 200,
		ignore_whitespace = true,
	},
	current_line_blame_formatter = "⋮  <author>, <author_time> - (<abbrev_sha>) <summary>",
	preview_config = { style = 'minimal', border = 'rounded' },

	signs = {
		add          = { text = '┃' },
		change       = { text = '┃' },
		delete       = { text = '▁' },
		topdelete    = { text = '▔' },
		changedelete = { text = '┋' },
		untracked    = { text = '' },
	},

	on_attach = require('user.settings.keymaps').gitsigns
}

if package.preload.scrollbar then
	require('scrollbar.handlers.gitsigns').setup()
end

vim.api.nvim_create_autocmd('BufEnter', {
	group = vim.api.nvim_create_augroup('AttachGitsigns', { clear = true }),
	desc = "Attach gitsigns upon opening a buffer",
	pattern = '*',
	callback = function(opts)
		gitsigns.attach(opts.bufnr)
	end,
})
