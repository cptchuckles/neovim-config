require 'user.settings.vim-options'
require 'user.settings.keymaps'

require('user.settings.buffer-augroups').setup()

local scheme = os.getenv("NVIM_COLORSCHEME") or "vim"
require('user.settings.colorscheme').setup({ scheme = scheme })
