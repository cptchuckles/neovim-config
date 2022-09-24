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

-- Autocommand that reloads neovim whenever you save the plugins.lua file
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
	use 'hrsh7th/nvim-cmp'                                    -- The completion engine plugin
	use 'hrsh7th/cmp-buffer'                                  -- Buffer completion
	use 'hrsh7th/cmp-path'                                    -- Path completion
	use 'hrsh7th/cmp-cmdline'                                 -- Command line completion
	use 'L3MON4D3/LuaSnip'                                    -- Snippet engine
	use 'saadparwaiz1/cmp_luasnip'                            -- Snippet completion
	use 'rafamadriz/friendly-snippets'                        -- A bunch of snippets
	use 'hrsh7th/cmp-nvim-lua'                                -- Lua support for nvim-cmp

	-- LSP
	use 'neovim/nvim-lspconfig'                               -- Official community LSP configs
	use 'hrsh7th/cmp-nvim-lsp'                                -- LSP support for nvim-cmp
	use 'Issafalcon/lsp-overloads.nvim'                       -- signature overload cycler
	use 'williamboman/mason.nvim'                             -- LSP/DAP/Format/Lint manager
	use 'williamboman/mason-lspconfig.nvim'
	use 'Hoffs/omnisharp-extended-lsp.nvim'                   -- Omnisharp specific bullshit
	use 'jose-elias-alvarez/null-ls.nvim'                     -- Null LS
	-- use 'ThePrimeagen/refactoring.nvim'                       -- Refactoring
	use 'j-hui/fidget.nvim'                                   -- LSP Progress fidget spinner

	-- DAP
	use 'mfussenegger/nvim-dap'                               -- DAP
	use 'rcarriga/nvim-dap-ui'                                -- DAP UI
	use 'theHamsta/nvim-dap-virtual-text'                     -- DAP Virtual Text
	-- use 'nvim-telescope/telescope-dap.nvim'

	-- Quality of Life enhancements
	use 'jlcrochet/vim-razor'                                 -- Attempt to edit razor with neovim
	use 'LunarVim/colorschemes'                               -- a bunch of colorschemes
	use 'folke/tokyonight.nvim'                               -- TokyoNight theme
	use 'kyazdani42/nvim-web-devicons'                        -- more icons and shit
	use 'lewis6991/gitsigns.nvim'                             -- Git Signs
	use 'lukas-reineke/indent-blankline.nvim'                 -- Indentation fanciness
	use 'numToStr/Comment.nvim'                               -- Auto-commenting
	use 'nvim-telescope/telescope.nvim'                       -- Telescope
	use 'nvim-telescope/telescope-ui-select.nvim'             -- Use telescope for more UI things
	use 'folke/trouble.nvim'                                  -- Pretty qickfix list
	use 'simrat39/symbols-outline.nvim'                       -- Symbols outliner
	use 'RRethy/vim-illuminate'                               -- Cursor-word highlighter + text objects
	use 'akinsho/bufferline.nvim'                             -- Bufferline - Tabs, but buffers!
	use 'Darazaki/indent-o-matic'                             -- Auto-detect buffer indentation
	use 'moll/vim-bbye'                                       -- Buffer deletion done right
	use {
		'kyazdani42/nvim-tree.lua',                           -- NvimTree
		requires = { 'kyazdani42/nvim-web-devicons' }
	}

	use {                                                     -- TREESITTER
		{
			'nvim-treesitter/nvim-treesitter',
			run = function()
				require('nvim-treesitter.install').update({ with_sync = true })
			end,
		},
		'nvim-treesitter/playground',                         -- TSPlayground to see the AST of a file
		'nvim-treesitter/nvim-treesitter-context',            -- Sticky code context
		'p00f/nvim-ts-rainbow',                               -- Color-code brackets and parens and shit
	}

	use {
		'andymass/vim-matchup',                               -- Better % operator (keywords and shit)
		event = 'VimEnter',
		config = function()
			vim.g.matchup_matchparen_deferred = 1
			vim.g.matchup_matchparen_offscreen = {}
		end,
	}

	-- Useful tools
	use 'kdheepak/lazygit.nvim'                               -- LazyGit
	use {
		'iamcco/markdown-preview.nvim',                       -- Markdown previewer in web browser
		run = function() vim.fn['mkdp#util#install']() end,
		cmd = 'MarkdownPreview',
		setup = function() vim.g.mkdp_filetypes = {'markdown'} end,
		ft = 'markdown',
		opt = true,
	}

	-- Sickass statusline thing
	use {
		'glepnir/galaxyline.nvim',
		branch = 'main',
		requires = { 'kyazdani42/nvim-web-devicons', opt = true },
	}

	-- Automatically set configuration after cloning packer.nvim
	-- Keep this at the end
	if PACKER_BOOTSTRAP then
		require('packer').sync()
	end
end)
