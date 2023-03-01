local O = {}

O.organize_imports_on_format = true
O.enable_import_completion = true
O.enable_roslyn_analyzers = true
O.analyze_open_documents_only = true

O.handlers = {
	["textDocument/definition"] = require('omnisharp_extended').handler,
}

O.cmd = { "omnisharp" }
O.filetypes = { 'cs', 'vb', 'razor', 'cshtml' }

local razor_dir = vim.fn.getenv("HOME") .. "/.razor"
if vim.fn.isdirectory(razor_dir) then
	vim.list_extend(O.cmd, {
		"--plugin",
		razor_dir .. "/OmniSharpPlugin/Microsoft.AspNetCore.Razor.OmniSharpPlugin.dll"
	})
end

return O
