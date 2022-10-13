set termguicolors number relativenumber cursorline list noexpandtab
set tabstop=4 softtabstop=4 shiftwidth=4
set listchars=tab:ﬀ\ ,lead:·,trail:¶
colorscheme murphy

nnoremap \\ <Nop>
let g:mapleader="\\"

nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

nnoremap <A-j> <Cmd>move .+1<CR>==
nnoremap <A-k> <Cmd>move .-2<CR>==
vnoremap <A-j> :move '>+1<CR>gv=gv
vnoremap <A-k> :move '<-2<CR>gv=gv

nnoremap <leader>` <Cmd>botright split+terminal<CR>
tnoremap <A-Esc> <Cmd>stopinsert<CR>
augroup TerminalSettings
	au!
	au TermOpen * setl nonumber norelativenumber nocursorline nohls nolist | startinsert
	au BufEnter term://* startinsert
augroup end

augroup HelpQfClose
	au!
	au FileType help,qf nnoremap <buffer> q <C-w><C-q>
augroup end
