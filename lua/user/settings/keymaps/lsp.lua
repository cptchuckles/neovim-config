local function try_fancy(action)
	local function try(f)
		return function()
			return pcall(function() f() end)
		end
	end

	local try_telescope = try(function()
		require('telescope.builtin')[action]({ show_line = false })
	end)

	local try_trouble = try(function()
		vim.api.nvim_command('Trouble '..action)
	end)

	return function()
		if not (try_telescope() or try_trouble()) then
			({
				lsp_declarations     = vim.lsp.buf.declaration,
				lsp_definitions      = vim.lsp.buf.definition,
				lsp_type_definitions = vim.lsp.buf.type_definition,
				lsp_references       = vim.lsp.buf.references,
				lsp_implementations  = vim.lsp.buf.implementation,
			})[action]()
		end
	end
end

local function nice_diagnostics(opts)
	opts = opts or {}
	opts.scope = opts.scope or 'document'
	return function()
		if not pcall(function() vim.api.nvim_command('Trouble ' .. opts.scope .. '_diagnostics') end) then
			vim.diagnostic.setqflist { open = true }
		end
	end
end

return function(bufnr)
	local function map(mode, lhs, rhs)
		local opts = { remap = false, silent = true, buffer = bufnr }
		vim.keymap.set(mode, lhs, rhs, opts)
	end

	map('n', 'K',      vim.lsp.buf.hover)
	map('n', '<C-]>',  try_fancy("lsp_definitions"))
	map('n', 'g<C-]>', try_fancy("lsp_references"))
	map('n', '<A-a>',  vim.lsp.buf.code_action)
	map('n', '<A-i>',  vim.diagnostic.open_float)

	map({'n', 'i'}, '<A-s>', vim.lsp.buf.signature_help)

	map('n', '[d', vim.diagnostic.goto_prev)
	map('n', ']d', vim.diagnostic.goto_next)

	map('n', '<leader>dD', nice_diagnostics { scope = 'workspace' })
	map('n', '<leader>dd', nice_diagnostics { scope = 'document' })
	map('n', '<leader>de', try_fancy("lsp_declarations"))
	map('n', '<leader>di', try_fancy("lsp_implementations"))
	map('n', '<leader>dr', vim.lsp.buf.rename)

	-- Formatting commands
	vim.api.nvim_buf_create_user_command(bufnr, 'Format', function()
		vim.api.nvim_command [[lua vim.lsp.buf.formatting()]]
	end, {})
	vim.api.nvim_buf_create_user_command(bufnr, 'FormatRange', vim.lsp.buf.range_formatting, { range = '%' })

	map('n', '<leader>F', [[<Cmd>Format<CR>]])
	map({ 'v', 'x' }, '<leader>f', [[:FormatRange<CR>]])
end
