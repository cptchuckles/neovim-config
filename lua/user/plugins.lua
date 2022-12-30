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

local plugins = {
	completion = {
		{ 'hrsh7th/nvim-cmp',                                 -- The completion engine plugin
			commit = nil },
		{ 'hrsh7th/cmp-buffer',                               -- Buffer completion
			commit = nil },
		{ 'hrsh7th/cmp-path',                                 -- Path completion
			commit = nil },
		{ 'hrsh7th/cmp-cmdline',                              -- Command line completion
			commit = nil },
		{ 'L3MON4D3/LuaSnip',                                 -- Snippet engine
			commit = nil },
		{ 'saadparwaiz1/cmp_luasnip',                         -- Snippet completion
			commit = nil },
		{ 'rafamadriz/friendly-snippets',                     -- A bunch of snippets
			commit = nil },
		{ 'hrsh7th/cmp-nvim-lua',                             -- Lua support for nvim-cmp
			commit = nil },
	},

	lsp = {
		{ 'neovim/nvim-lspconfig',                            -- Official community LSP configs
			commit = nil },
		{ 'hrsh7th/cmp-nvim-lsp',                             -- LSP support for nvim-cmp
			commit = nil },
		{ 'Issafalcon/lsp-overloads.nvim',                    -- signature overload cycler
			commit = nil },
		{ 'williamboman/mason.nvim',                          -- LSP/DAP/Format/Lint manager
			commit = nil },
		{ 'williamboman/mason-lspconfig.nvim',                -- Setup lspconfig for mason-installed LSPs
			commit = nil },
		{ 'Hoffs/omnisharp-extended-lsp.nvim',                -- Omnisharp specific bullshit
			commit = nil },
		{ 'jose-elias-alvarez/null-ls.nvim',                  -- Null LS
			commit = nil },
		--  { 'ThePrimeagen/refactoring.nvim',                   -- Refactoring
		-- 	commit = nil },
		{ 'j-hui/fidget.nvim',                                -- LSP Progress fidget spinner
			commit = nil },
	},

	dap = {
		{ 'mfussenegger/nvim-dap',                            -- DAP
			commit = nil },
		{ 'rcarriga/nvim-dap-ui',                             -- DAP UI
			commit = nil },
		{ 'theHamsta/nvim-dap-virtual-text',                  -- DAP Virtual Text
			commit = nil },
		{ 'nvim-telescope/telescope-dap.nvim',
			commit = nil },
	},

	quality_of_life = {
		themeing = {
			{ 'jlcrochet/vim-razor',                          -- Attempt to edit razor with neovim
				commit = nil },
			{ 'LunarVim/colorschemes',                        -- a bunch of colorschemes
				commit = nil },
			{ 'folke/tokyonight.nvim',                        -- TokyoNight theme
				commit = nil },
			{ 'kyazdani42/nvim-web-devicons',                 -- more icons and shit
				commit = nil },
			{ 'Darazaki/indent-o-matic',                      -- Auto-detect buffer indentation
				commit = nil },
			{ 'norcalli/nvim-colorizer.lua',                  -- Colorize hex color codes
				commit = nil },
		},
		editing = {
			{ 'numToStr/Comment.nvim',                        -- Auto-commenting
				commit = nil },
			{ 'RRethy/vim-illuminate',                        -- Cursor-word highlighter + text objects
				commit = nil },
			{ 'andymass/vim-matchup',                         -- Better % operator (keywords and shit)
				commit = nil,
				event = 'VimEnter',
				config = function()
					vim.g.matchup_matchparen_deferred = 1
					vim.g.matchup_matchparen_offscreen = {}
				end,
			},
			{ 'toppair/peek.nvim',                            -- Markdown previewer in web browser
				commit = nil,
				run = 'deno task --quiet build:fast',
				ft = 'markdown',
				opt = true,
				config = function() require 'user.peek' end,
			},
			{ 'windwp/nvim-autopairs',                        -- Automagically match punctuation pairs
				commit = nil },
		},
		layout = {
			{ 'lukas-reineke/indent-blankline.nvim',          -- Indentation fanciness
				commit = nil },
			{ 'lewis6991/gitsigns.nvim',                      -- Git Signs
				commit = nil },
			{ 'simrat39/symbols-outline.nvim',                -- Symbols outliner
				commit = nil },
			{ 'moll/vim-bbye',                                -- Buffer deletion done right
				commit = nil },
			{ 'glepnir/galaxyline.nvim',                      -- Sickass statusline
				commit = nil,
				branch = 'main',
				requires = { 'kyazdani42/nvim-web-devicons', opt = true },
			},
			{ 'SmiteshP/nvim-navic',                          -- Winbar plugin to show context
				commit = nil,
				requires = 'neovim/nvim-lspconfig',
			},
		},
	},

	treesitter = {
		{ 'nvim-treesitter/nvim-treesitter',
			commit = nil,
			run = function()
				require('nvim-treesitter.install').update({ with_sync = true })
			end,
		},
		{ 'nvim-treesitter/playground',                       -- TSPlayground to see the AST of a file
			commit = nil },
		{ 'p00f/nvim-ts-rainbow',                             -- Color-code brackets and parens and shit
			commit = nil },
	},

	workspace_tools = {
		{ 'kdheepak/lazygit.nvim',                            -- LazyGit
			commit = nil },
		{ 'nvim-telescope/telescope.nvim',                    -- Telescope
			commit = nil },
		{ 'nvim-telescope/telescope-ui-select.nvim',          -- Use telescope for more UI things
			commit = nil },
		{ 'folke/trouble.nvim',                               -- Pretty qickfix list
			commit = nil },
		{ 'kyazdani42/nvim-tree.lua',                         -- NvimTree
			commit = nil,
			requires = { 'kyazdani42/nvim-web-devicons' },
		},
	},
}

-- Install plugins here
return packer.startup(function(use)
	-- Bare necessities
	use 'wbthomason/packer.nvim'    -- Let packer manage itself
	use 'nvim-lua/popup.nvim'       -- Nvim implementation of Vim Popup API
	use 'nvim-lua/plenary.nvim'     -- Useful lua functions used by lots of plugins

	use 'lewis6991/impatient.nvim'  -- cache bytecode plugins for fast startup
	use 'tjdevries/lazy-require.nvim'       -- Plugin lazy load/require

	use(plugins.completion)
	use(plugins.lsp)
	use(plugins.dap)
	use(plugins.quality_of_life.themeing)
	use(plugins.quality_of_life.editing)
	use(plugins.quality_of_life.layout)
	use(plugins.treesitter)
	use(plugins.workspace_tools)

	-- Automatically set configuration after cloning packer.nvim
	-- Keep this at the end
	if PACKER_BOOTSTRAP then
		require('packer').sync()
	end
end)
