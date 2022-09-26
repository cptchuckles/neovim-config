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

local base_opts = {
	on_attach    = require('user.lsp.handlers').on_attach,
	capabilities = require('user.lsp.handlers').capabilities,
}

mason.setup()

mason_lsp.setup()
mason_lsp.setup_handlers {
	-- Automatically invoke lspconfig setup for every installed LSP server
	function (server_name)
		local opts = base_opts
		local has_settings, settings = pcall(require, 'user.lsp.settings.'..server_name)
		if has_settings then
			opts = vim.tbl_deep_extend("force", opts, settings)
		end
		require('lspconfig')[server_name].setup(opts)
	end,
}
