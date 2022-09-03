local M = {}

function M.on_attach(bufnr)
	local function telescope_references()
		if not (pcall(function() require('telescope.builtin').lsp_references { show_line = false } end)
		    or  pcall(function() vim.api.nvim_command [[Trouble lsp_references]] end))
			then vim.lsp.buf.references()
		end
	end

	local function trouble_diagnostics(opts)
		opts = opts or {}
		opts.scope = vim.F.if_nil(opts.scope, "document")
		local diagnose = {
			document  = function() vim.api.nvim_command [[Trouble  document_diagnostics]] end,
			workspace = function() vim.api.nvim_command [[Trouble workspace_diagnostics]] end,
		}
		return function()
			if not pcall(diagnose[opts.scope]) then
				vim.diagnostic.setqflist { open = true }
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

	-- Formatting commands
	vim.api.nvim_buf_create_user_command(bufnr, 'Format', function()
		vim.api.nvim_command [[lua vim.lsp.buf.formatting()]]
	end, {})
	vim.api.nvim_buf_create_user_command(bufnr, 'FormatRange', vim.lsp.buf.range_formatting, { range = '%' })

	map('n', "<leader>F", [[<Cmd>Format<CR>]])
	map({ 'v', 'x' }, '<leader>f', [[:FormatRange<CR>]])
end

return M
