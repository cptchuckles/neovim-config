local M = {}

M.setup = function()
	local signs = {
		{ name = "DiagnosticSignError", text = "" },
		{ name = "DiagnosticSignWarn", text = "" },
		{ name = "DiagnosticSignHint", text = "" },
		{ name = "DiagnosticSignInfo", text = "" },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, {
			texthl = sign.name,
			text = sign.text,
			numhl = "",
		})
	end

	local config = {
		virtual_text = {
			severity = vim.diagnostic.severity.ERROR,
			spacing = 2,
			prefix = "",
		},
		signs = {
			active = signs,
		},
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			focusable = false,
			style = "minimal",
			border = "rounded",
			source = "if_many",
			header = "",
			prefix = "· ",
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

local function lsp_highlight_document(client)
	-- Set autocommands conditional on server_capabilities
	if client.resolved_capabilities.document_highlight then
		vim.api.nvim_exec([[
			augroup lsp_document_highlight
				au! * <buffer>
				au CursorHold <buffer> lua vim.lsp.buf.document_highlight()
				au CursorMoved <buffer> lua vim.lsp.buf.clear_references()
			augroup end
		]],
		false)
	end
end

local have_telescope, telescope = pcall(require, 'telescope.builtin')

local function lsp_keymaps(bufnr)
	local map = function(mode, lhs, rhs)
		local opts = { remap = false, buffer = bufnr }
		vim.keymap.set(mode, lhs, rhs, opts)
	end

	map('n', '<C-]>', vim.lsp.buf.definition)
	map('n', 'g<C-]>', function()
		if have_telescope then
			telescope.lsp_references()
		else
			vim.lsp.buf.references()
		end
	end)
	map('n', 'K',  vim.lsp.buf.hover)
	map({'n', 'i'}, '<A-i>', vim.lsp.buf.signature_help)

	map('n', '[d', function() vim.diagnostic.goto_prev({ border = "rounded" }) end)
	map('n', ']d', function() vim.diagnostic.goto_next({ border = "rounded" }) end)

	map('n', '<leader>dd', function() vim.diagnostic.open_float({ border = "rounded" }) end)
	map('n', '<leader>dD', function()
		if have_telescope then
			telescope.diagnostics()  -- Full diagnostics because telescope makes looking at things easy
		else
			vim.diagnostic.setqflist { open = true, severity = { min = vim.diagnostic.severity.WARN } }
		end
	end)
	map('n', '<leader>de', vim.lsp.buf.declaration)
	map('n', '<leader>di', vim.lsp.buf.implementation)
	map('n', '<leader>dr', vim.lsp.buf.rename)
	map('n', '<leader>da', vim.lsp.buf.code_action)

	vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
end

M.on_attach = function(client, bufnr)
	if client.name == "tsserver" then
		client.resolved_capabilities.document_formatting = false
	end
	if client.server_capabilities.signatureHelpProvider then
		require('lsp-overloads').setup(client, {
			keymaps = {
				previous_signature = '<A-K>',
				next_signature = '<A-J>',
				previous_parameter = '<A-L>',
				next_parameter = '<A-H>',
			},
		})
	end
	lsp_keymaps(bufnr)
	lsp_highlight_document(client)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

local cmp_status_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if not cmp_status_ok then
	print("Unable to load cmp_nvim_lsp")
	return
end

M.capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

return M
