local status_ok, nls = pcall(require, 'null-ls')
if not status_ok then
	print("Couldn't load 'null-ls'")
	return
end

nls.setup {
	on_attach = require('user.lsp.handlers').on_attach,
	capabilities = require('user.lsp.handlers').capabilities,

	sources = {
		-- nls.builtins.code_actions.eslint_d,  -- Mason
		-- nls.builtins.code_actions.proselint,
		-- nls.builtins.code_actions.refactoring,  -- Kind of annoying and half useless
		nls.builtins.code_actions.shellcheck,
		nls.builtins.code_actions.xo,  -- Js/Ts

		-- nls.builtins.completion.luasnip,
		-- nls.builtins.completion.tags,

		-- nls.builtins.diagnostics.actionlint,  -- GitHub actions
		nls.builtins.diagnostics.checkmake,
		-- nls.builtins.diagnostics.chktex,
		nls.builtins.diagnostics.cppcheck,
		-- nls.builtins.diagnostics.eslint_d,  -- Mason
		-- nls.builtins.diagnostics.gccdiag,  -- TODO: Can't build this fuckin thing because of a Conan error
		-- nls.builtins.diagnostics.gdlint,  -- This thing bitches too much about my style choices
		-- nls.builtins.diagnostics.haml_lint,
		nls.builtins.diagnostics.tidy,  -- HTML/XML
		-- nls.builtins.diagnostics.shellcheck,  -- Mason
		-- nls.builtins.diagnostics.tsc,
		nls.builtins.diagnostics.xo,  -- Js/Ts

		nls.builtins.formatting.gdformat,
		nls.builtins.formatting.jq,
		nls.builtins.formatting.nginx_beautifier,
		nls.builtins.formatting.tidy,  -- HTML/XML
	},
}
