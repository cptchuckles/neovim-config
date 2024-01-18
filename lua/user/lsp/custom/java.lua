return function(config)
	require('java').setup({ jdk = { auto_install = false }})
	require('lspconfig').jdtls.setup(vim.tbl_deep_extend("error", config, {
		settings = {
			java = {
				configuration = {
					runtimes = {
						name = "system-jdk",
						path = "/usr/lib/jvm/default-runtime",
						default = true,
					}
				}
			}
		}
	}))
end
