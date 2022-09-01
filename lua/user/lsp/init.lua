local status_ok, _ = pcall(require, 'lspconfig')
if not status_ok then
	print("Couldn't load 'lspconfig'")
	return
end

require('user.lsp.handlers').setup()
require 'user.lsp.mason'
require 'user.lsp.null-ls'
