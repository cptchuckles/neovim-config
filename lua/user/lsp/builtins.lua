local handlers = require('user.lsp.handlers')

require('lspconfig').gdscript.setup {
	on_attach    = handlers.on_attach,
	capabilities = handlers.capabilities,
}
