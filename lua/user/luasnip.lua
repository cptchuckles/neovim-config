local status_ok, luasnip = pcall(require, 'luasnip')
if not status_ok then
	print("Couldn't load 'luasnip'")
	return
end

local vscode_ok, vscode_loader = pcall(require, 'luasnip/loaders/from_vscode')
if not vscode_ok then
	print("Couldn't load 'luasnip/loaders/from_vscode'")
else
	vscode_loader.lazy_load()
end

luasnip.filetype_extend("ruby", {
	"jekyll",
	-- "rails",
})
-- luasnip.filetype_extend("cpp",  {"unreal"})

return luasnip
