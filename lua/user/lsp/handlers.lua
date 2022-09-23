local M = {}

M.setup = function()
	local signs = {
		{ name = "DiagnosticSignError", text = "" },
		{ name = "DiagnosticSignWarn",  text = "" },
		{ name = "DiagnosticSignInfo",  text = "" },
		{ name = "DiagnosticSignHint",  text = "ﯧ" },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, {
			texthl = sign.name,
			text   = sign.text,
			numhl  = "",
		})
	end

	local config = {
		virtual_text = {
			severity = {
				min = vim.diagnostic.severity.WARN,
			},
			spacing  = 2,
			prefix   = "⋮",
		},
		signs = {
			active = signs,
		},
		update_in_insert = true,
		severity_sort    = true,
		underline = {
			severity = {
				min = vim.diagnostic.severity.INFO,
			},
		},
		float = {
			focusable = false,
			style     = "minimal",
			border    = "rounded",
			source    = "if_many",
			header    = "",
			prefix    = "· ",
		},
	}

	vim.diagnostic.config(config)

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
	})

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "rounded",
	})
end

M.on_attach = function(client, bufnr)
	if pcall(function() return vim.api.nvim_buf_get_var(bufnr, 'UserLspAttached') == 1 end) then
		return
	end
	vim.api.nvim_buf_set_var(bufnr, 'UserLspAttached', 1)

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

	require('user.settings.keymaps').lsp_setup(bufnr)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

local cmp_status_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if not cmp_status_ok then
	print("Unable to load cmp_nvim_lsp")
	return
end

M.capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

return M
