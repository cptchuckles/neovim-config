local status_ok, comment = pcall(require, 'Comment')
if not status_ok then
	print("Couldn't load Comment.nvim")
	return
end

comment.setup {
	padding = true,
	sticky = true,
	ignore = '^$',

	toggler = {
		line = '<C-_>',
	},

	opleader = {
		line = 'g<C-_>',
	},

	extra = {
		above = 'g/O',
		below = 'g/o',
		eol   = 'g/A',
	},

	mappings = {
		basic = true,
		extra = true,
		extended = false,
	},

	post_hook = nil,
}
