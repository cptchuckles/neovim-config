-- Automatically install packer.nvim
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = vim.fn.system {
		'git',
		'clone',
		'--depth',
		'1',
		'https://github.com/wbthomason/packer.nvim',
		install_path,
	}
	print 'Installing packer.nvim; close and reopen Neovim...'
	vim.api.nvim_command [[packadd packer.nvim]]
end

-- Autocommand that resyncs packer whenever you save the plugins.lua file
vim.api.nvim_create_autocmd('BufWritePost', {
	group = vim.api.nvim_create_augroup('packer_user_config', { clear = true }),
	desc = 'Update the plugin list every time you save plugins.lua',
	pattern = vim.fn.stdpath('config') .. '/lua/user/plugins.lua',
	callback = function(opts)
		vim.api.nvim_command('source ' .. opts.file)
		require('packer').sync()
	end,
})

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, 'packer')
if not status_ok then
	print("Couldn't load 'packer'")
	return
end

-- Let packer use a rounded-border popup window
packer.init {
	display = {
		open_fn = function()
			return require('packer.util').float { border = 'rounded' }
		end
	}
}

-- Install plugins here
return packer.startup(function(use)
	-- Bare necessities
	use 'wbthomason/packer.nvim'                              -- Let packer manage itself
	use 'nvim-lua/popup.nvim'                                 -- Nvim implementation of Vim Popup API
	use 'nvim-lua/plenary.nvim'                               -- Useful lua functions used by lots of plugins

	use 'lewis6991/impatient.nvim'                            -- cache bytecode plugins for fast startup
	use 'tjdevries/lazy.nvim'                                 -- Plugin lazy load/require

	-- Completion
	use { 'hrsh7th/nvim-cmp',                                    -- The completion engine plugin
		commit = nil }
	use { 'hrsh7th/cmp-buffer',                                  -- Buffer completion
		commit = nil }
	use { 'hrsh7th/cmp-path',                                    -- Path completion
		commit = nil }
	use { 'hrsh7th/cmp-cmdline',                                 -- Command line completion
		commit = nil }
	use { 'L3MON4D3/LuaSnip',                                    -- Snippet engine
		commit = nil }
	use { 'saadparwaiz1/cmp_luasnip',                            -- Snippet completion
		commit = nil }
	use { 'rafamadriz/friendly-snippets',                        -- A bunch of snippets
		commit = nil }
	use { 'hrsh7th/cmp-nvim-lua',                                -- Lua support for nvim-cmp
		commit = nil }

	-- LSP
	use { 'neovim/nvim-lspconfig',                               -- Official community LSP configs
		commit = nil }
	use { 'hrsh7th/cmp-nvim-lsp',                                -- LSP support for nvim-cmp
		commit = nil }
	use { 'Issafalcon/lsp-overloads.nvim',                       -- signature overload cycler
		commit = nil }
	use { 'williamboman/mason.nvim',                             -- LSP/DAP/Format/Lint manager
		commit = nil }
	use { 'williamboman/mason-lspconfig.nvim',
		commit = nil }
	use { 'Hoffs/omnisharp-extended-lsp.nvim',                   -- Omnisharp specific bullshit
		commit = nil }
	use { 'jose-elias-alvarez/null-ls.nvim',                     -- Null LS
		commit = nil }
	-- use { 'ThePrimeagen/refactoring.nvim',                       -- Refactoring
	-- 	commit = nil }
	use { 'j-hui/fidget.nvim',                                   -- LSP Progress fidget spinner
		commit = nil }

	-- DAP
	use { 'mfussenegger/nvim-dap',                               -- DAP
		commit = nil }
	use { 'rcarriga/nvim-dap-ui',                                -- DAP UI
		commit = nil }
	use { 'theHamsta/nvim-dap-virtual-text',                     -- DAP Virtual Text
		commit = nil }
	use { 'nvim-telescope/telescope-dap.nvim',
		commit = nil }

	-- Quality of Life enhancements
	use { 'jlcrochet/vim-razor',                                 -- Attempt to edit razor with neovim
		commit = nil }
	use { 'LunarVim/colorschemes',                               -- a bunch of colorschemes
		commit = nil }
	use { 'folke/tokyonight.nvim',                               -- TokyoNight theme
		commit = nil }
	use { 'kyazdani42/nvim-web-devicons',                        -- more icons and shit
		commit = nil }
	use { 'lewis6991/gitsigns.nvim',                             -- Git Signs
		commit = nil }
	use { 'lukas-reineke/indent-blankline.nvim',                 -- Indentation fanciness
		commit = nil }
	use { 'numToStr/Comment.nvim',                               -- Auto-commenting
		commit = nil }
	use { 'nvim-telescope/telescope.nvim',                       -- Telescope
		commit = nil }
	use { 'nvim-telescope/telescope-ui-select.nvim',             -- Use telescope for more UI things
		commit = nil }
	use { 'folke/trouble.nvim',                                  -- Pretty qickfix list
		commit = nil }
	use { 'simrat39/symbols-outline.nvim',                       -- Symbols outliner
		commit = nil }
	use { 'RRethy/vim-illuminate',                               -- Cursor-word highlighter + text objects
		commit = nil }
	use { 'akinsho/bufferline.nvim',                             -- Bufferline - Tabs, but buffers!
		commit = nil }
	use { 'Darazaki/indent-o-matic',                             -- Auto-detect buffer indentation
		commit = nil }
	use { 'moll/vim-bbye',                                       -- Buffer deletion done right
		commit = nil }
	use { 'norcalli/nvim-colorizer.lua',                         -- Colorize hex color codes
		commit = nil }
	use {
		'kyazdani42/nvim-tree.lua',                           -- NvimTree
		commit = nil,
		requires = { 'kyazdani42/nvim-web-devicons' }
	}

	use {                                                     -- TREESITTER
		{
			'nvim-treesitter/nvim-treesitter',
			commit = '27cba73df9ddca00c066c7ebb514576a99bb8b2c',
			run = function()
				require('nvim-treesitter.install').update({ with_sync = true })
			end,
		},
		{ 'nvim-treesitter/playground',                         -- TSPlayground to see the AST of a file
			commit = nil },
		{ 'nvim-treesitter/nvim-treesitter-context',            -- Sticky code context
			commit = nil },
		{ 'p00f/nvim-ts-rainbow',                               -- Color-code brackets and parens and shit
			commit = nil },
	}

	use {
		'andymass/vim-matchup',                               -- Better % operator (keywords and shit)
		commit = 'e59d5c73f1bf696c7de9fc13090a240d1ceb13f7',
		event = 'VimEnter',
		config = function()
			vim.g.matchup_matchparen_deferred = 1
			vim.g.matchup_matchparen_offscreen = {}
		end,
	}

	-- Useful tools
	use { 'kdheepak/lazygit.nvim',                               -- LazyGit
		commit = nil }
	use {
		'iamcco/markdown-preview.nvim',                       -- Markdown previewer in web browser
		commit = nil,
		run = function() vim.fn['mkdp#util#install']() end,
		cmd = 'MarkdownPreview',
		setup = function() vim.g.mkdp_filetypes = {'markdown'} end,
		ft = 'markdown',
		opt = true,
	}

	-- Sickass statusline thing
	use {
		'glepnir/galaxyline.nvim',
		commit = nil,
		branch = 'main',
		requires = { 'kyazdani42/nvim-web-devicons', opt = true },
	}

	-- Automatically set configuration after cloning packer.nvim
	-- Keep this at the end
	if PACKER_BOOTSTRAP then
		require('packer').sync()
	end
end)
