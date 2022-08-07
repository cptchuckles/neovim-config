local fn = vim.fn

-- Automatically install packer.nvim
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system {
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	}
	print "Installing packer.nvim; close and reopen Neovim..."
	vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
	augroup packer_user_config
		autocmd!
		autocmd BufWritePost plugins.lua source <afile> | PackerSync
	augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Let packer use a rounded-border popup window
packer.init {
	display = {
		open_fn = function()
			return require("packer.util").float { border = "rounded" }
		end
	}
}

-- Install plugins here
return packer.startup(function(use)
	use "wbthomason/packer.nvim" -- Let packer manage itself
	use "nvim-lua/popup.nvim"    -- Nvim implementation of Vim Popup API
	use "nvim-lua/plenary.nvim"  -- Useful lua functions used by lots of plugins

	-- Automatically set configuration after cloning packer.nvim
	-- Keep this at the end
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
