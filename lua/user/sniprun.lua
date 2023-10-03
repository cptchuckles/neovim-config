local status_ok, sniprun = pcall(require, 'sniprun')
if not status_ok then
	print("Couldn't load 'sniprun'")
	return
end


sniprun.setup {
	display = {
		"Terminal",
		"VirtualTextOk",
	}
}
