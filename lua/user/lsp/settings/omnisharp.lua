local base_cmd = { 'omnisharp' }

local razor_dir = os.getenv('DOTNET_RAZOR_PATH') or (os.getenv('HOME') .. '/.razor')
local omnisharp_razor_plugin =
	razor_dir .. '/OmniSharpPlugin/Microsoft.AspNetCore.Razor.OmniSharpPlugin.dll'

local O = {
	cmd = base_cmd,
	filetypes = { 'cs', 'vb' },
	organize_imports_on_format = true,
	enable_import_completion = true,
	enable_roslyn_analyzers = true,
	analyze_open_documents_only = true,
}

O.on_new_config = function(new_config, new_root_dir)
	-- Reset command to prevent repetitive argument buildup
	new_config.cmd = vim.list_extend({}, base_cmd)

	if vim.fn.filereadable(omnisharp_razor_plugin) then
		if #vim.fn.glob(new_root_dir .. '/**/*.razor') > 0 or
			#vim.fn.glob(new_root_dir .. '/**/*.cshtml') > 0
		then
			vim.list_extend(new_config.cmd, {
				'--plugin',
				omnisharp_razor_plugin,
			})
			vim.list_extend(new_config.filetypes, {
				'razor',
				'cshtml',
			})
		end
	end

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
