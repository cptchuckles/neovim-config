local lspconfig = require('lspconfig')
local configure = require('lspconfig.configs')

local rzls = vim.fn.getenv('HOME') .. '/.razor/rzls'
if not vim.fn.filereadable(rzls) then
	return false
end

if not configure.rzls then
	configure.rzls = {
		default_config = {
			name = 'rzls',
			cmd = {
				rzls,
				'-lsp',
				'--trace', '2',  --verbose logging
			},
			filetypes = { 'razor', 'cshtml' },
			root_dir = function(fname)
				return lspconfig.util.root_pattern('*.sln', '.git')(fname)
			end,
			settings = {},
		}
	}
end

return true
