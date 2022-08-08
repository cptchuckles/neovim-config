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

	use 'kyazdani42/nvim-web-devicons'  -- more icons and shit

	-- cmp plugins
	use 'hrsh7th/nvim-cmp'    -- The completion engine plugin
	use 'hrsh7th/cmp-buffer'  -- buffer completion
	use 'hrsh7th/cmp-path'    -- path completion
	use 'hrsh7th/cmp-cmdline' -- command line completion
	use 'saadparwaiz1/cmp_luasnip'  -- snippet completion

	-- snippet engines
	use 'L3MON4D3/LuaSnip'    -- snippet engine
	use 'rafamadriz/friendly-snippets'  -- a bunch of snippets

	-- markdown previewer in web browser
	use {
		'iamcco/markdown-preview.nvim',
		run = 'cd app && yarn install',
		cmd = 'MarkdownPreview',
		opt = true,
	}

	-- better % operator (keywords and shit)
	use {
		'andymass/vim-matchup',
		event = "VimEnter",
		config = function()
			vim.cmd [[
				let g:matchup_matchparen_offscreen = { 'method': 'popup', }
			]]
		end,
	}

	-- Git Signs
	use {
		'lewis6991/gitsigns.nvim',
		requires = {'nvim-lua/plenary.nvim'},
		config = function()
			require('gitsigns').setup {
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns

					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- Navigation
					map('n', ']c', function()
						if vim.wo.diff then return ']c' end
						vim.schedule(function() gs.next_hunk() end)
						return '<Ignore>'
					end, { expr = true })

					map('n', '[c', function()
						if vim.wo.diff then return ']c' end
						vim.schedule(function() gs.prev_hunk() end)
						return '<Ignore>'
					end, { expr = true })

					-- Actions
					map({'n', 'v'}, '<leader>gs', ':Gitsigns stage_hunk<CR>')
					map({'n', 'v'}, '<leader>gr', ':Gitsigns reset_hunk<CR>')
					map('n', '<leader>gS', gs.stage_buffer)
					map('n', '<leader>gu', gs.undo_stage_hunk)
					map('n', '<leader>gR', gs.reset_buffer)
					map('n', '<leader>gp', gs.preview_hunk)
					map('n', '<leader>gb', function() gs.blame_line{full=true} end)
					map('n', '<leader>gB', gs.toggle_current_line_blame)
					map('n', '<leader>gd', gs.diffthis)
					map('n', '<leader>gD', function() gs.diffthis('~') end)
					map('n', '<leader>gX', gs.toggle_deleted)
					-- text object
					map({'o', 'x'}, 'ic', ':<C-U>Gitsigns select_hunk<CR>')
				end,
			}
		end,
	}

	-- Sickass statusline thing (TODO)
	-- use {
	-- 'glepnir/galaxyline.nvim',
	-- 	branch = 'main',
	-- 	requires = { 'kyazdani42/nvim-web-devicons', opt = true },
	-- }

	-- Automatically set configuration after cloning packer.nvim
	-- Keep this at the end
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
