-- :help options
local options = {
	backup         = false,                           -- creates a backup file
	background     = "dark",                          -- changes how colors are drawn
	clipboard      = "unnamedplus",                   -- uses the system clipboard
	cmdheight      = 2,                               -- more space in cmdline for messages
	completeopt    = { "menuone", "noselect" },       -- cmp stuff
	pumheight      = 15,                              -- pop up menu height
	conceallevel   = 0,                               -- makes `` visible in markdown
	fileencoding   = "utf-8",                         -- file encoding
	hlsearch       = true,                            -- hilight last search query
	ignorecase     = true,                            -- case sensitivity in search
	mouse          = "a",                             -- allows sacrilege
	showmode       = true,                            -- shows current editing mode
	showtabline    = 2,                               -- always show tabs
	smartcase      = true,                            -- case-sensitive when search has caps
	smartindent    = true,                            -- hope it doesn't fuck me over
	splitbelow     = true,                            -- hsplit goes down, not up
	splitright     = false,                           -- vsplit goes right, not left
	swapfile       = false,                           -- create a swapfile while editing
	termguicolors  = true,                            -- set term gui colors (well supported)
	timeoutlen     = 400,                             -- leader timeout in msec
	undofile       = false,                           -- persistent undo file
	updatetime     = 200,                             -- faster completion (400ms default)
	writebackup    = false,                           -- when a file is open by other program
	expandtab      = false,                           -- auto turn tabs to spaces
	shiftwidth     = 4,                               -- charcount of "one indentation"
	tabstop        = 4,                               -- spaces to insert for a tab with et
	cursorline     = true,                            -- underline the whole line at cursor
	number         = true,                            -- show the line number in the gutter
	relativenumber = true,                            -- show line numbers as offset from cursor
	numberwidth    = 4,                               -- width of numberline gutter (default 4)
	signcolumn     = "yes",                           -- always show the sign column
	wrap           = false,                           -- word-wrap long lines
	scrolloff      = 4,                               -- top/bottom line margin from cursor
	sidescrolloff  = 8,                               -- horizontal margin from cursor (no wrap)
	shortmess      = "a",                             -- how to display messages in the msg line
	guifont        = "BlexMono Nerd Font",            -- font to use in graphical nvim frontends
	list           = true,                            --
	listchars      = "tab:ﬀ ,lead:·,trail:¶",         -- postemptive space example:       
	formatoptions  = "n2ljp",                         -- magic!
	textwidth      = 120,                             -- sets desired document width
	colorcolumn    = "+1",                            -- marks desired rightmost document edge
	laststatus     = 3,                               -- global statusline at the bottom of nvim
	joinspaces     = true,                            -- Use two spaces when joining sentences
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
vim.g.shada = "'0f0"          -- what to save in the ShaDa file
