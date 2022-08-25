return {
	organize_imports_on_format = true,
	enable_import_completion = true,
	enable_roslyn_analyzers = true,  -- Consider turning this off so it stops talking shit about my code
	filetypes = { "cs", "vb", --[[ "cshtml", "razor" ]] },  -- Absolutely futile.

	handlers = {
		["textDocument/definition"] = require('omnisharp_extended').handler,
	},

	-- These are goddamn useless
	-- They get set and you can see them in the config, but they don't appear to *do* anything
	-- because I assume they control launch options *from VSCode*, but nvim-lspconfig doesn't
	-- seem to give half a rat's ass about these settings.
	-- I found the above snake_case equivalents to some of these (e.g. enable_import_completion)
	-- by opening a C# source file and typing `:lua =vim.lsp.get_active_clients()[1]` and
	-- reading through the table that gets dumped out.
	settings = {
		csharp = {
			inlayHints = {
				parameters = {
					enabled = true,
					forIndexerParameters = true,
					forLiteralParameters = true,
					forObjectCreationParameters = true,
					forOtherParameters = true,
				},
				types = {
					enabled = true,
					forImplicitObjectCreation = true,
					forImplicitVariableTypes = true,
					forLambdaParameterTypes = true,
				},
			},
		},
		omnisharp = {
			enableImportCompletion = true,
			enableMsBuildLoadProjectsOnDemant = false,
			enableRoslynAnalyzers = true,
			organizeImportsOnFormat = true,
		},
		razor = {
			plugin = {
				-- Nope
				path = "/home/grendel/.vscode/extensions/ms-dotnettools.csharp-1.25.0-linux-x64/.razor/rzls.dll",
			},
		},
	},
}
