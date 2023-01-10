-- Core modules
require 'user.plugins'
require 'user.settings'

-- Default configurations
require 'impatient'
require('fidget').setup()
require('colorizer').setup()
require('guess-indent').setup()

-- Editing & Completion
require 'user.cmp'
require 'user.comment'
require 'user.autopairs'
require 'user.lsp'

-- Layout & Tools
require 'user.nvim-tree'
require 'user.symbols-outline'
require 'user.telescope'
require 'user.trouble'
require 'user.web-tools'

-- Buffer Enhancements
require 'user.treesitter'
require 'user.scrollbar'
require 'user.gitsigns'
require 'user.illuminate'
require 'user.indent-blankline'
require 'user.galaxyline'
