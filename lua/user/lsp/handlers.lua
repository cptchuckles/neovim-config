local M = {}

M.on_attach = function(client, bufnr)
	if pcall(function() return vim.api.nvim_buf_get_var(bufnr, 'UserLspAttached') == 1 end) then
		return
	end
	vim.api.nvim_buf_set_var(bufnr, 'UserLspAttached', 1)

	require('user.lsp.navic').try_attach(client, bufnr)

	require('user.settings.keymaps').lsp_setup(client, bufnr)

	client.server_capabilities.semanticTokensProvider = nil
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

local cmp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if cmp_ok then
	M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)
else
	print("Couldn't load 'cmp_nvim_lsp' nor update capabilities")
end

M.capabilities.offsetEncoding = { 'utf-16' }

return M
