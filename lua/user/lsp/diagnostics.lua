local signs = {
	{ name = "DiagnosticSignError", text = "󰅙" },
	{ name = "DiagnosticSignWarn",  text = "" },
	{ name = "DiagnosticSignInfo",  text = "" },
	{ name = "DiagnosticSignHint",  text = "󰌶" },
}

for _, sign in ipairs(signs) do
	vim.fn.sign_define(sign.name, {
		texthl = sign.name,
		text   = sign.text,
		numhl  = "",
	})
end

vim.diagnostic.config {
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
