# Neovim Config

My custom configuration for [Neovim](https://github.com/neovim/neovim), intended to build out
functionality to rival modern IDEs.

This started out as a config for personal use, but is garnering some interest from other neovim
users.

## Major feature plugins

### Language support

**AST**
- [Treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - Language parsing, highlighting,
  and editing features

**LSP and Diagnostics**
- [Mason](https://github.com/williamboman/mason.nvim) - Plugin management for LSP, DAP, Formatters
  and Linters
- [null-ls](https://github.com/jose-elias-alvarez/null-ls.nvim) - Plugs external linters into LSP
  Diagnostics and Code Actions

**Intellisense and Completion**
- [LuaSnip](https://github.com/L3MON4D3/LuaSnip) - Snippet engine
- [nvim-cmp](https://github.com/nvim-cmp/nvim-cmp) - Code and snippet completion

### Interface enhancements

**Layout**
- [NvimTree](https://github.com/kyazdani42/nvim-tree.lua) - Filesystem browsing tree
- [Symbols-Outline](https://github.com/simrat39/symbols-outline.nvim) - LSP-powered symbol outliner
  for code files
- [Galaxyline](https://github.com/glepnir/galaxyline.nvim) - Customized editor statusline
- [Bufferline](https://github.com/akinsho/bufferline.nvim) - Tabular display for open buffers

**Workspace Tools**
- [Telescope](https://github.com/nvim-telescope/telescope.nvim) - Powerful search/browse for files,
  regex, and sybmols throughout whole workspace
- [Trouble](https://github.com/folke/trouble.nvim) - Enhanced list for diagnostics, references, and
  search results
- [Lazygit](https://github.com/kdheepak/lazygit.nvim) - In-Editor integration for the
  [lazygit](https://github.com/jesseduffield/lazygit) version control TUI

**User Experience**
- [Gitsigns](https://github.com/lewis6991/gitsigns.nvim) - See and manipulate git hunks, commits,
  and diffs in-editor
- [Treesitter-Context](https://github.com/nvim-treesitter/nvim-treesitter-context) - Sticky code
  context to always see your current scope at the top of the buffer
- [IndentBlankline](https://github.com/lukas-reineke/indent-blankline.nvim) - Clearly visualize
  indentation and scope
- [Tokyonight](https://github.com/folke/tokyonight.nvim) - Simply the best colorscheme

### Todo
- [ ] Finish integrating DAP support
- [ ] Maybe add [which-key](https://github.com/folke/which-key.nvim) to better organize keybinds and
  make them more discoverable
