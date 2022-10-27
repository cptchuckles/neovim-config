local M = {}

M.on_attach = function(client, bufnr)
	if client.name == "tsserver" then
		client.resolved_capabilities.document_formatting = false
	end

	if client.server_capabilities.signatureHelpProvider then
		require('lsp-overloads').setup(client, {
			keymaps = {
				previous_signature = '<A-K>',
				next_signature     = '<A-J>',
				previous_parameter = '<A-L>',
				next_parameter     = '<A-H>',
			},
		})
	end

	if pcall(function() return vim.api.nvim_buf_get_var(bufnr, 'UserLspAttached') == 1 end) then
		return
	end
	vim.api.nvim_buf_set_var(bufnr, 'UserLspAttached', 1)

	require('user.settings.keymaps').lsp_setup(client, bufnr)
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

local cmp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if cmp_ok then
	M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)
else
	print("Couldn't load 'cmp_nvim_lsp'")
end

M.capabilities = vim.tbl_deep_extend('force', M.capabilities, { offsetEncoding = { 'utf-8' } })

return M
