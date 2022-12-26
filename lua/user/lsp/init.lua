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

local handlers = require('user.lsp.handlers')

require('lspconfig.ui.windows').default_options.border = "rounded"

require('lspconfig').gdscript.setup {
	on_attach    = handlers.on_attach,
	capabilities = handlers.capabilities,
}

require 'user.lsp.mason'
require 'user.lsp.null-ls'

require('user.lsp.navic').setup()
