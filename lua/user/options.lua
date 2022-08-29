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
local aug_wipe_buffers = vim.api.nvim_create_augroup('WipeUnwantedBuffers', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
	group = aug_wipe_buffers,
	desc = 'Wipe buffers and remove colorcolumn for certain kinds of buffers',
	pattern = { 'Trouble', 'netrw', 'qf', 'nofile' },
	callback = function(opts)
		if opts.match ~= 'Trouble' then vim.bo[opts.buf].bufhidden = 'wipe' end
		vim.wo[vim.fn.bufwinid(opts.buf)].colorcolumn = ''  -- No colorcolumn on these buffers
	end,
})
vim.api.nvim_create_autocmd('BufLeave', {
	group = aug_wipe_buffers,
	desc = 'Delete [No Name] buffers upon leaving',
	pattern = '[No Name]',
	callback = function(opts)
		vim.api.nvim_buf_delete(opts.buf)
	end,
})

-- Fold settings
vim.api.nvim_create_autocmd('FileType', {
	group = vim.api.nvim_create_augroup('JsonYamlFoldingSettings', { clear = true }),
	desc = 'Set indent-based folding at level 2 for json and yaml files',
	pattern = { 'json', 'yaml' },
	callback = function(opts)
		vim.schedule(function()
			local wid = vim.fn.bufwinid(opts.buf)
			vim.wo[wid].foldmethod = 'indent'
			vim.wo[wid].foldlevel = 2
		end)
	end,
})

-- Terminal settings
local aug_terminal_settings = vim.api.nvim_create_augroup('TerminalSettings', { clear = true })
vim.api.nvim_create_autocmd('TermOpen', {
	group = aug_terminal_settings,
	desc = 'Set some nice defaults for opening a terminal buffer',
	pattern = '*',
	callback = function(opts)
		local wid = vim.fn.bufwinid(opts.buf)
		vim.wo[wid].number         = false
		vim.wo[wid].relativenumber = false
		vim.wo[wid].cursorline     = false
		vim.wo[wid].list           = false
		vim.bo[opts.buf].modifiable = true
		vim.api.nvim_command [[startinsert]]
	end,
})
vim.api.nvim_create_autocmd('BufEnter', {
	group = aug_terminal_settings,
	desc = 'Enter insert mode automatically when entering a terminal buffer',
	pattern = 'term://*',
	command = 'startinsert',
})

-- Theme settings
vim.cmd [[
	augroup ColorSchemeOverride
		au!
		au ColorScheme *
		\ 	highlight! TabLineFill cterm=NONE gui=NONE ctermbg=Darkgray guibg=#333333
		\|	highlight! Todo cterm=bold gui=bold ctermbg=Yellow ctermfg=Black guibg=Yellow guifg=Black
		\|	highlight! Comment cterm=italic gui=italic
		\|	highlight! TSComment cterm=italic gui=italic
		\|	highlight! Whitespace cterm=NONE ctermfg=8 guifg=#3a3a3a
		\|	highlight! link WinSeparator LineNr
		\|	highlight! GitSignsCurrentLineBlame cterm=italic,bold ctermfg=Lightgray gui=italic,bold guifg=#4A4A4A
		\|	highlight! DiagnosticVirtualTextError cterm=bold,italic gui=bold,italic ctermfg=darkred guifg=darkred
		\|	highlight! DiagnosticVirtualTextWarn cterm=bold,italic gui=bold,italic ctermfg=yellow guifg=#777700
		\|	highlight! DiagnosticVirtualTextInfo cterm=bold,italic gui=bold,italic ctermfg=lightyellow guifg=#666644
		\|	highlight! IndentBlanklineChar guifg=#2b2f38 gui=nocombine
		\|	highlight! link IndentBlanklineSpaceChar Whitespace
		\|	highlight! link IndentBlanklineIndent1 CursorLine
		\|	highlight! IndentBlanklineIndent2 guibg=NONE gui=nocombine
		\|	highlight! link IlluminatedWordText LspReferenceText
		\|	highlight! link IlluminatedWordRead LspReferenceRead
		\|	highlight! link IlluminatedWordWrite LspReferenceWrite
		\|	highlight! link NvimTreeIndentMarker WinSeparator
	augroup end

	colorscheme onedarker
]]
