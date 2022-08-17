-- :help options
local options = {
	backup = false,            -- creates a backup file
	background = "dark",       -- changes how colors are drawn
	clipboard = "unnamedplus", -- uses the system clipboard
	cmdheight = 2,             -- more space in cmdline for messages
	completeopt = { "menuone", "noselect" }, -- cmp stuff
	conceallevel = 0,          -- makes `` visible in markdown
	fileencoding = "utf-8",    -- file encoding
	hlsearch = true,           -- hilight last search query
	ignorecase = true,         -- case sensitivity in search
	mouse = "a",               -- allows sacrilege
	pumheight = 10,            -- pop up menu height
	showmode = true,           -- shows current editing mode
	showtabline = 2,           -- always show tabs
	smartcase = true,          -- case-sensitive when search has caps
	smartindent = true,        -- hope it doesn't fuck me over
	splitbelow = true,         -- hsplit goes down, not up
	splitright = false,        -- vsplit goes right, not left
	swapfile = false,          -- create a swapfile while editing
	termguicolors = true,      -- set term gui colors (well supported)
	timeoutlen = 400,          -- leader timeout in msec
	undofile = false,          -- persistent undo file
	updatetime = 200,          -- faster completion (400ms default)
	writebackup = false,       -- when a file is open by other program
	expandtab = false,         -- auto turn tabs to spaces
	shiftwidth = 4,            -- charcount of "one indentation"
	tabstop = 4,               -- spaces to insert for a tab with et
	cursorline = true,         -- underline the whole line at cursor
	number = true,             -- show the line number in the gutter
	relativenumber = true,     -- show line numbers as offset from cursor
	numberwidth = 4,           -- width of numberline gutter (default 4)
	signcolumn = "yes",        -- always show the sign column
	wrap = true,               -- word-wrap long lines
	scrolloff = 4,             -- top/bottom line margin from cursor
	sidescrolloff = 8,         -- horizontal margin from cursor (no wrap)
	shortmess = "a",           -- how to display messages in the msg line
	guifont = "BlexMono NF",   -- font to use in graphical nvim frontends
	list = true,
	listchars = "tab:→ ,lead:·,trail:¶",
	formatoptions = "n2ljp",   -- magic!
	textwidth = 120,           -- sets desired document width
	colorcolumn = "+1",        -- marks desired rightmost document edge
}
vim.opt.iskeyword:append "-"   -- add '-' to iskeyword chars

for k, v in pairs(options) do
	vim.opt[k] = v
end


-- netrw settings
vim.g.netrw_liststyle = 3     -- tree style listing
vim.g.netrw_browse_split = 4  -- open file in previous window
vim.g.netrw_banner = 0        -- no banner
vim.g.netrw_usetab = 1        -- use netrw-<C-Tab> mapping
vim.g.netrw_wiw = 32          -- window width (cols)

-- Buffer wiping
vim.cmd [[
	augroup WipeUnwantedBuffers
		au!
		au FileType netrw setlocal bufhidden=wipe  " Prevent netrw from making entries in the buffer list
	augroup end
]]

-- terminal settings
vim.cmd [[
	augroup TerminalSettings
		au!
		au TermOpen * setl nonumber norelativenumber nocursorline nolist modifiable | startinsert
		au BufEnter * if &buftype == 'terminal' | startinsert | elseif &buftype == 'help' | setl colorcolumn= | endif
	augroup end
]]

-- theme settings
vim.cmd [[
	colorscheme tomorrow
	highlight TabLineFill cterm=NONE gui=NONE ctermbg=Darkgray guibg=#333333
	highlight Todo cterm=bold gui=bold ctermbg=Yellow ctermfg=Black guibg=Yellow guifg=Black
	highlight Comment cterm=italic gui=italic
	highlight Whitespace cterm=NONE ctermfg=8 guifg=#3a3a3a
	highlight GitSignsCurrentLineBlame cterm=italic,bold ctermfg=Lightgray gui=italic,bold guifg=#4A4A4A
	highlight DiagnosticVirtualTextError cterm=bold,italic gui=bold,italic ctermfg=darkred guifg=darkred
]]
