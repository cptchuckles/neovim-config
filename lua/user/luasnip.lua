local status_ok, luasnip = pcall(require, 'luasnip')
if not status_ok then
	print("Couldn't load 'luasnip'")
	return
end

require('luasnip.loaders.from_vscode').lazy_load()

luasnip.filetype_extend("ruby", {
	"jekyll",
	-- "rails",
})
-- luasnip.filetype_extend("cpp",  {"unreal"})

return luasnip
