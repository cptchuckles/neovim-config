local O = {}

O.organize_imports_on_format = true
O.enable_import_completion = true
O.enable_roslyn_analyzers = true
O.analyze_open_documents_only = true

O.handlers = {
	["textDocument/definition"] = require('omnisharp_extended').handler,
}

O.filetypes = { 'cs', 'vb', 'razor', 'cshtml' }

local base_cmd = { "omnisharp" }

local razor_dir = vim.fn.getenv("HOME") .. "/.razor"
if vim.fn.isdirectory(razor_dir) then
	vim.list_extend(base_cmd, {
		"--plugin",
		razor_dir .. "/OmniSharpPlugin/Microsoft.AspNetCore.Razor.OmniSharpPlugin.dll"
	})
end

O.cmd = base_cmd

O.on_new_config = function(new_config, new_root_dir)
	-- Reset command to prevent repetitive argument buildup
	new_config.cmd = vim.list_extend({}, base_cmd)

	table.insert(new_config.cmd, '-z') -- https://github.com/OmniSharp/omnisharp-vscode/pull/4300
	vim.list_extend(new_config.cmd, { '-s', new_root_dir })
	vim.list_extend(new_config.cmd, { '--hostPID', tostring(vim.fn.getpid()) })
	table.insert(new_config.cmd, 'DotNet:enablePackageRestore=false')
	vim.list_extend(new_config.cmd, { '--encoding', 'utf-8' })
	table.insert(new_config.cmd, '--languageserver')

	if new_config.enable_editorconfig_support then
		table.insert(new_config.cmd, 'FormattingOptions:EnableEditorConfigSupport=true')
	end

	if new_config.organize_imports_on_format then
		table.insert(new_config.cmd, 'FormattingOptions:OrganizeImports=true')
	end

	if new_config.enable_ms_build_load_projects_on_demand then
		table.insert(new_config.cmd, 'MsBuild:LoadProjectsOnDemand=true')
	end

	if new_config.enable_roslyn_analyzers then
		table.insert(new_config.cmd, 'RoslynExtensionsOptions:EnableAnalyzersSupport=true')
	end

	if new_config.enable_import_completion then
		table.insert(new_config.cmd, 'RoslynExtensionsOptions:EnableImportCompletion=true')
	end

	if new_config.sdk_include_prereleases then
		table.insert(new_config.cmd, 'Sdk:IncludePrereleases=true')
	end

	if new_config.analyze_open_documents_only then
		table.insert(new_config.cmd, 'RoslynExtensionsOptions:AnalyzeOpenDocumentsOnly=true')
	end
end

return O
