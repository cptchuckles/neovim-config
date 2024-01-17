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

	vim.api.nvim_create_autocmd('BufWritePost', {
		group = vim.api.nvim_create_augroup('JavaAutoCompile', { clear = true }),
		desc = 'Build gradle or maven projects post write',
		pattern = '*.java',
		callback = function()
			local compiler
			if vim.fn.filereadable("mvnw") == 1 then
				compiler = "!./mvnw compile"
			elseif vim.fn.filereadable("gradlew") == 1 then
				compiler = "!./gradlew build"
			else
				return
			end

			vim.fn.execute(compiler, "silent")
		end,
	})
end
