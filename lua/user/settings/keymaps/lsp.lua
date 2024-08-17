---@param f fun()
local function try(f)
	return function()
		return pcall(f)
	end
end

---@param action string
local function try_fancy(action)
	local try_telescope = try(function()
		require('telescope.builtin')[action]({ show_line = false })
	end)

	local try_trouble = try(function()
		vim.api.nvim_command('Trouble ' .. action)
	end)

	return function()
		if not (try_telescope() or try_trouble()) then
			({	lsp_declarations     = vim.lsp.buf.declaration,
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
		if not pcall(function() vim.api.nvim_command('Trouble diagnostics ' .. (opts.scope == "document" and "filter.buf=0" or "")) end) then
			vim.diagnostic.setqflist { open = true }
		end
	end
end

return function(client, bufnr)
	local function map(mode, lhs, rhs, opts)
		opts = vim.tbl_extend("force", opts or {}, { remap = false, silent = true, buffer = bufnr })
		vim.keymap.set(mode, lhs, rhs, opts)
	end

	--- Custom actions from Hoffs/omnisharp-extended-lsp.nvim should be used when the client is Omnisharp
	---@param method_name string
	---@param opts? table
	---@return function
	local function maybe_omnisharp(method_name, opts)
		return client.name == 'omnisharp'
			and require('omnisharp_extended')[((opts or {}).telescope and 'telescope_' or '') .. method_name]
			or try_fancy(method_name)
	end

	map('n', 'K',      vim.lsp.buf.hover,         { desc = "LSP show information about symbol under cursor" })
	map('n', '<A-a>',  vim.lsp.buf.code_action,   { desc = "LSP code actions" })
	map('n', '<A-i>',  vim.diagnostic.open_float, { desc = "Show line diagnostics" })
	map('n', 'g<C-]>', maybe_omnisharp('lsp_references',  { telescope = true }), { desc = "LSP list references" })
	map('n', '<C-]>',  maybe_omnisharp('lsp_definitions', { telescope = true }), { desc = "LSP go to definition" })
	map('n', '<leader>di', maybe_omnisharp('lsp_implementations', { telescope = true}),
		{ desc = "LSP list implementations" })

	map({ 'n', 'i' }, '<A-s>', vim.lsp.buf.signature_help, { desc = "LSP signature help" })

	map('n', '[d', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
	map('n', ']d', vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })

	map('n', '<leader>dD', nice_diagnostics { scope = 'workspace' }, { desc = "Show workspace diagnostics" })
	map('n', '<leader>dd', nice_diagnostics { scope = 'document' },  { desc = "Show document diagnostics" })
	map('n', '<leader>de', try_fancy('lsp_declarations'),            { desc = "LSP go to declaration of symbol" })
	map('n', '<leader>dr', vim.lsp.buf.rename,                       { desc = "LSP rename symbol" })

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
