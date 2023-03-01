local lspconfig = require('lspconfig')

return function(config)
	if require 'user.lsp.custom.rzls' then
		lspconfig.rzls.setup(config)
	end
end
