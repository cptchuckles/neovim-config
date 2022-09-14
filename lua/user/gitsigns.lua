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
		add          = {hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'    },
		change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn' },
		delete       = {hl = 'GitSignsDelete', text = '▁', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn' },
		topdelete    = {hl = 'GitSignsDelete', text = '▔', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn' },
		changedelete = {hl = 'GitSignsChange', text = '┊', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn' },
	},

	on_attach = require('user.settings.keymaps.gitsigns')
}
