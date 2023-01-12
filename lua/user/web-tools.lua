local status_ok, webtools = pcall(require, 'web-tools')
if not status_ok then
	print("Couldn't load 'web-tools'")
	return
end

webtools.setup {
	keymaps = {
		rename = nil,  -- by default use the same rename command as lspconfig
	}
}
