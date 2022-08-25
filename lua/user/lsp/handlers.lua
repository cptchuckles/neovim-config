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

local function lsp_keymaps(bufnr)
	local function telescope_references()
		local have_telescope, telescope = pcall(require, 'telescope.builtin')
		if have_telescope then
			telescope.lsp_references(
				require('telescope.themes').get_dropdown {
					include_declaration = false,
					layout_config = { width = 0.7, },  -- TODO: fix this not inheriting from defaults
				}
			)
		elseif not pcall(vim.cmd, [[ Trouble lsp_references ]]) then
			vim.lsp.buf.references()
		end
	end

	local function trouble_diagnostics(opts)
		opts = opts or {}
		opts.scope = vim.F.if_nil(opts.scope, "document")
		local diagnose = {
			document  = function() vim.api.nvim_command[[Trouble  document_diagnostics]] end,
			workspace = function() vim.api.nvim_command[[Trouble workspace_diagnostics]] end,
		}
		return function()
			if not pcall(diagnose[opts.scope]) then
				vim.diagnostic.setqflist({ open = true })
			end
		end
	end

	local function map(mode, lhs, rhs)
		local opts = { remap = false, buffer = bufnr }
		vim.keymap.set(mode, lhs, rhs, opts)
	end

	map('n', 'K',      vim.lsp.buf.hover)
	map('n', '<C-]>',  vim.lsp.buf.definition)
	map('n', 'g<C-]>', telescope_references)
	map('n', '<A-a>',  vim.lsp.buf.code_action)
	map('n', '<A-i>',  function() vim.diagnostic.open_float({ border = "rounded" }) end)

	map({'n', 'i'}, '<A-s>', vim.lsp.buf.signature_help)

	map('n', '[d', function() vim.diagnostic.goto_prev({ border = "rounded" }) end)
	map('n', ']d', function() vim.diagnostic.goto_next({ border = "rounded" }) end)

	map('n', '<leader>dD', trouble_diagnostics { scope = 'workspace' })
	map('n', '<leader>dd', trouble_diagnostics { scope = 'document' })
	map('n', '<leader>de', vim.lsp.buf.declaration)
	map('n', '<leader>di', vim.lsp.buf.implementation)
	map('n', '<leader>dr', vim.lsp.buf.rename)

	vim.cmd [[ command! -range=% Format execute 'lua vim.lsp.buf.range_formatting()' ]]
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
