local M = {}

function M.setup()
	local navic_ok, navic = pcall(require, 'nvim-navic')
	if not navic_ok then
		print("Couldn't load nvim-navic")
		return
	end

	local icons = {}
	for k, v in pairs(require('user.settings.icons')) do
		icons[k] = v .. ' '
	end

	icons.Package = " " -- block scopes are "packages", which looks weird with my default package icon

	navic.setup {
		icons = icons,
		highlight = true,
		separator = '  ',
		depth_limit = 6,
		depth_limit_indicator = '…',
		safe_output = true,
	}
end

function M.try_attach(client, bufnr)
	if client.name == "astro" then
		print("nvim-navic does not play nice with astro")
		return
	end

	if client.server_capabilities.documentSymbolProvider then
		require('nvim-navic').attach(client, bufnr)
		vim.wo[vim.fn.bufwinid(bufnr)].winbar = "%{%v:lua.require('nvim-navic').get_location()%}"
	end
end

return M
