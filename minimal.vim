set termguicolors number relativenumber cursorline list noexpandtab smartindent
set tabstop=4 softtabstop=4 shiftwidth=4
set listchars=tab:ﬀ\ ,lead:·,trail:¶
set clipboard+=unnamedplus

augroup ChangeColorScheme
	au!
	au ColorScheme * highlight! Normal guibg=NONE
augroup end

colorscheme habamax

nnoremap \\ <Nop>
let g:mapleader="\\"

" Niceties
nnoremap <leader>s <Cmd>set hls!<CR>
nnoremap <A-l> <Cmd>ls<CR>:b
nnoremap <C-q> :bd%<CR>
nnoremap ZZ :wqa<CR>
nnoremap ZQ :qa!<CR>

" Window navigation
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Line moving
nnoremap <A-j> <Cmd>move .+1<CR>==
nnoremap <A-k> <Cmd>move .-2<CR>==
vnoremap <A-j> :move '>+1<CR>gv=gv
vnoremap <A-k> :move '<-2<CR>gv=gv

" Indenting
vnoremap < <gv
vnoremap > >gv

" Terminal settings
nnoremap <leader>` <Cmd>botright split+terminal<CR>
tnoremap <A-Esc> <Cmd>stopinsert<CR>
augroup TerminalSettings
	au!
	au TermOpen * setl nonumber norelativenumber nocursorline nohls nolist | startinsert
	au BufEnter term://* startinsert
augroup end

" Close help and qflist
augroup HelpQfClose
	au!
	au FileType help,qf nnoremap <buffer> q <C-w><C-q>
augroup end

" Add settings for gitcommit message buffers
augroup GitCommitMessages
	au!
	au FileType gitcommit setl textwidth=67 colorcolumn=+1 expandtab
augroup end
