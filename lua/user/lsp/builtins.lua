local lspconfig = require('lspconfig')
local handlers = require('user.lsp.handlers')

local user_default = {
	on_attach    = handlers.on_attach,
	capabilities = handlers.capabilities,
}

require('user.lsp.custom')(user_default)

lspconfig.gdscript.setup(user_default)

require('java').setup()
lspconfig.jdtls.setup(user_default)
