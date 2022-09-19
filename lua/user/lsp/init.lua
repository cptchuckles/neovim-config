local status_ok, lspconfig = pcall(require, 'lspconfig')
if not status_ok then
	print("Couldn't load 'lspconfig'")
	return
end

local handlers = require('user.lsp.handlers')
handlers.setup()

lspconfig.gdscript.setup {
	on_attach    = handlers.on_attach,
	capabilities = handlers.capabilities,
}

require 'user.lsp.mason'
require 'user.lsp.null-ls'
