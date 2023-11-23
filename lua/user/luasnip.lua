local status_ok, luasnip = pcall(require, 'luasnip')
if not status_ok then
	print("Couldn't load 'luasnip'")
	return
end

require('luasnip.loaders.from_vscode').lazy_load()

local extensions = {
	ruby = {
		"jekyll",
		"rails",
	},
	javascript = {
		"jsdoc",
	},
	cpp = {
		"unreal",
	},
}

for lang, tbl in pairs(extensions) do
	luasnip.filetype_extend(lang, tbl)
end

return luasnip
