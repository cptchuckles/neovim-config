local mason_ok, mason = pcall(require, 'mason')
if not mason_ok then
	print("Couldn't load 'mason'")
	return
end

local mason_lsp_ok, mason_lsp = pcall(require, 'mason-lspconfig')
if not mason_lsp_ok then
	print("Couldn't load 'mason-lspconfig'")
	return
end

mason.setup {
	ui = {
		border = "rounded",
	},
	registries = {
		'github:nvim-java/mason-registry',
		'github:mason-org/mason-registry',
	},
}

mason_lsp.setup {
	ensure_installed = {
		"lua_ls",
		"vimls",
	},
}

local environment_conditions = {
	jdtls = {"NVIM_USE_JAVA", "1"},
}

mason_lsp.setup_handlers {
	-- Automatically invoke lspconfig setup for every installed LSP server
	function (server_name)
		local env_var = environment_conditions[server_name]
		if env_var ~= nil and os.getenv(env_var[1]) ~= env_var[2] then
			return
		end
		local opts = vim.tbl_deep_extend("force", {}, require('user.lsp.handlers'))
		local has_settings, settings = pcall(require, 'user.lsp.settings.'..server_name)
		if has_settings then
			opts = vim.tbl_deep_extend("force", opts, settings)
		end
		require('lspconfig')[server_name].setup(opts)
	end,
}
