-- Core modules
require 'user.plugins'
require 'user.settings'

-- Editing & Completion
require 'user.cmp'
require 'user.lsp'
require 'user.comment'
-- Layout & Tools
require 'user.nvim-tree'
require 'user.symbols-outline'
require 'user.telescope'
require 'user.trouble'
require 'user.bufferline'
-- Buffer Enhancements
require 'user.gitsigns'
require 'user.treesitter'
require 'user.indent-blankline'
require 'user.illuminate'

-- Default configurations
require 'impatient'
require 'indent-o-matic'
require('treesitter-context').setup({
	mode = 'cursor',
	-- separator = '─',
	patterns = {
		lua = {
			'variable_declaration',
			'table_constructor',
		},
	},
})
