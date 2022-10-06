-- :help options
local options = {
	background     = "dark",                          -- changes how colors are drawn
	backup         = false,                           -- creates a backup file
	clipboard      = "unnamedplus",                   -- uses the system clipboard
	cmdheight      = 1,                               -- space in cmdline for messages
	colorcolumn    = "+1",                            -- marks desired rightmost document edge
	completeopt    = { "menuone", "noselect" },       -- cmp stuff
	conceallevel   = 0,                               -- makes `` visible in markdown
	cursorline     = true,                            -- underline the whole line at cursor
	expandtab      = false,                           -- auto turn tabs to spaces
	fileencoding   = "utf-8",                         -- file encoding
	formatoptions  = "n2ljp",                         -- magic!
	guifont        = "BlexMono Nerd Font",            -- font to use in graphical nvim frontends
	hlsearch       = true,                            -- hilight last search query
	ignorecase     = true,                            -- case sensitivity in search
	joinspaces     = true,                            -- Use two spaces when joining sentences
	laststatus     = 3,                               -- global statusline at the bottom of nvim
	list           = true,                            --
	listchars      = "tab:ﬀ ,lead:·,trail:¶",         -- postemptive space example:       
	mouse          = "a",                             -- allows sacrilege
	number         = true,                            -- show the line number in the gutter
	numberwidth    = 4,                               -- width of numberline gutter (default 4)
	pumheight      = 15,                              -- pop up menu height
	relativenumber = true,                            -- show line numbers as offset from cursor
	scrolloff      = 4,                               -- top/bottom line margin from cursor
	shiftwidth     = 4,                               -- charcount of "one indentation"
	shortmess      = "a",                             -- how to display messages in the msg line
	showmode       = true,                            -- shows current editing mode
	showtabline    = 1,                               -- 0:never, 1:when many, 2:always
	sidescrolloff  = 8,                               -- horizontal margin from cursor (no wrap)
	signcolumn     = "yes",                           -- always show the sign column
	smartcase      = false,                           -- case-sensitive when search has caps
	smartindent    = true,                            -- hope it doesn't fuck me over
	splitbelow     = true,                            -- hsplit goes down, not up
	splitright     = false,                           -- vsplit goes right, not left
	swapfile       = false,                           -- create a swapfile while editing
	tabstop        = 4,                               -- spaces to insert for a tab with et
	termguicolors  = true,                            -- set term gui colors (well supported)
	textwidth      = 120,                             -- sets desired document width
	timeoutlen     = 400,                             -- leader timeout in msec
	undofile       = false,                           -- persistent undo file
	updatetime     = 200,                             -- faster completion (400ms default)
	wrap           = false,                           -- word-wrap long lines
	writebackup    = false,                           -- when a file is open by other program
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
