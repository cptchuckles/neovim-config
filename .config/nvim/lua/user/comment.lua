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
		line = 'g//',
		block = 'gb/',
	},

	opleader = {
		line = 'g/',
		block = 'gb',
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

	pre_hook = nil,
	post_hook = nil,
}
