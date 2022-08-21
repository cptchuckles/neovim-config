local mason_ok, mason = pcall(require, 'mason')
if not mason_ok then
	print("Couldn't load 'mason'")
	return
end

local mason_lsp_ok, mason_lsp = pcall(require, 'mason-lspconfig')
if not mason_lsp_ok then
	print("Couldn't load 'mason-lspconfig'")
	return
end

local handlers_ok, lsp_handlers = pcall(require, 'user.lsp.handlers')
if not handlers_ok then
	print("Couldn't load 'user.lsp.handlers'")
	return
end

local opts = {
	on_attach = lsp_handlers.on_attach,
	capabilities = lsp_handlers.capabilities,
}

mason.setup()

mason_lsp.setup()
mason_lsp.setup_handlers {
	-- Automatically invoke lspconfig setup for every installed LSP server
	function (server_name)
		require('lspconfig')[server_name].setup(opts)
	end,

	sumneko_lua = function ()
		local lua_opts = vim.tbl_deep_extend("force", require('user.lsp.settings.sumneko_lua'), opts)
		require('lspconfig').sumneko_lua.setup(lua_opts)
	end,

	jsonls = function ()
		local json_opts = vim.tbl_deep_extend("force", require('user.lsp.settings.jsonls'), opts)
		require('lspconfig').jsonls.setup(json_opts)
	end,

	omnisharp = function ()
		local omnisharp_opts = {
			handlers = {
				["textDocument/definition"] = require('omnisharp_extended').handler,
			},
		}
		require('lspconfig').omnisharp.setup(
			vim.tbl_deep_extend("force", omnisharp_opts, opts)
		)
	end,
}
