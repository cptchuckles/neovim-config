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

local opts = {
	on_attach    = require('user.lsp.handlers').on_attach,
	capabilities = require('user.lsp.handlers').capabilities,
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
		local omnisharp_opts = vim.tbl_deep_extend("force", require('user.lsp.settings.omnisharp'), opts)
		require('lspconfig').omnisharp.setup(omnisharp_opts)
	end,
}
