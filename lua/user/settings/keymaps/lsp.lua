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
		vim.api.nvim_command('Trouble ' .. action)
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

return function(client, bufnr)
	local function map(mode, lhs, rhs, opts)
		opts = vim.tbl_extend("force", opts or {}, { remap = false, silent = true, buffer = bufnr })
		vim.keymap.set(mode, lhs, rhs, opts)
	end

	map('n', 'K',      vim.lsp.buf.hover,            { desc = "LSP show information about symbol under cursor" })
	map('n', 'g<C-]>', try_fancy("lsp_references"),  { desc = "LSP list references" })
	map('n', '<A-a>',  vim.lsp.buf.code_action,      { desc = "LSP code actions" })
	map('n', '<A-i>',  vim.diagnostic.open_float,    { desc = "Show line diagnostics" })
	map('n', '<C-]>', (function()
		if client.name == 'omnisharp' then
			-- Override general <C-]> mappping for default vim one,
			-- since omnisharp_extended doesn't work with Telescope or Trouble
			return vim.lsp.buf.definition
		else
			return try_fancy("lsp_definitions")
		end
	end)(), { desc = "LSP go to definition" })

	map({ 'n', 'i' }, '<A-s>', vim.lsp.buf.signature_help, { desc = "LSP signature help" })

	map('n', '[d', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
	map('n', ']d', vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })

	map('n', '<leader>dD', nice_diagnostics { scope = 'workspace' }, { desc = "Show workspace diagnostics" })
	map('n', '<leader>dd', nice_diagnostics { scope = 'document' }, { desc = "Show document diagnostics" })
	map('n', '<leader>de', try_fancy("lsp_declarations"), { desc = "LSP go to declaration of symbol" })
	map('n', '<leader>di', try_fancy("lsp_implementations"), { desc = "LSP list implementations" })
	map('n', '<leader>dr', vim.lsp.buf.rename, { desc = "LSP rename symbol" })

	-- Formatting commands
	vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(opts)
		local format_opts = { async = true }
		if opts.range > 0 then
			format_opts.range = {
				{ opts.line1, 0 },
				{ opts.line2, 0 },
			}
		end
		vim.lsp.buf.format(format_opts)
	end, { range = true })

	map({ 'n', 'v' }, '<leader>F', [[<Cmd>Format<CR>]])
end
