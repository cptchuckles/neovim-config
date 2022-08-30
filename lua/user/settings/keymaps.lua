local opts = { remap = false, silent = true }

-- Shorten function name
local map = vim.keymap.set

-- Remap leader key
map("", "\\", "<Nop>", opts)
vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"


-- Normal -----------------------------------------------------------------------------
-- Better window navigation
map("n", "<A-h>", "<C-w>h", opts)
map("n", "<A-j>", "<C-w>j", opts)
map("n", "<A-k>", "<C-w>k", opts)
map("n", "<A-l>", "<C-w>l", opts)

-- Bbye commands
map("n", "<C-q>", ":Bdelete<CR>", opts)

map("n", "ZZ", ":wqa<CR>", opts)
map("n", "ZQ", ":qa!<CR>", opts)

local have_nvtree, nvtree = pcall(require, 'nvim-tree.api')
if have_nvtree then
	map("n", "<leader>e", nvtree.tree.toggle, opts)
else
	map("n", "<leader>e", "<Cmd>Lex 20<CR>", opts)
end
map("n", "<leader>E", ":SymbolsOutline<CR>", opts)
map("n", "<leader>s", ":set hls!<CR>", opts)
map("n", "<leader>w", ":set wrap!<CR>", opts)

local have_telescope, telescope = pcall(require, 'telescope.builtin')
if have_telescope then
	map("n", "<leader>ta", telescope.live_grep, opts)
	map("n", "<leader>to", function() telescope.live_grep { grep_open_files = true } end, opts)
	map("n", "<leader>*",  telescope.grep_string, opts)
	map("n", "<leader>tf", telescope.find_files, opts)
	map("n", "<leader>ts", telescope.treesitter, opts)
	map("n", "<C-l>",      telescope.buffers, opts)
	map("n", "<leader>qh", telescope.quickfixhistory, opts)
	map("n", "<leader>rg", telescope.current_buffer_fuzzy_find, opts)
	map("n", "<leader>T",  telescope.resume, opts)
else
	map("n", "<C-l>", ":ls<CR>:b", opts)
end

map("n", "<leader>gg", ":LazyGit<CR>", opts)

-- Window resizing with CTRL-Arrowkey
map("n", "<C-Up>", "2<C-w>-", opts)
map("n", "<C-Down>", "2<C-w>+", opts)
map("n", "<C-Left>", "2<C-w><", opts)
map("n", "<C-Right>", "2<C-w>>", opts)

-- Navigate buffers
map("n", "<C-n>", "<Cmd>bnext<CR>", opts)
map("n", "<C-p>", "<Cmd>bprev<CR>", opts)


-- Insert -----------------------------------------------------------------------------
-- Move text up/down while in insert mode
map("i", "<A-j>", "<Cmd>m .+1<CR><C-o>==", opts)
map("i", "<A-k>", "<Cmd>m .-2<CR><C-o>==", opts)


-- Visual -----------------------------------------------------------------------------
-- Stay in indent mode
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Move text up and down
map("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
map("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)

-- Overwrite paste
map("v", "p", '"_dp', opts)

-- Collimate on =
map({'v', 'x'}, '<leader>c', [[:!column --table -s= -o=<CR>]], opts)


-- Terminal ---------------------------------------------------------------------------
map("n", "<leader>`", "<Cmd>split+terminal<CR>", opts)

-- Window switch from terminal
map("t", "<A-h>", "<Cmd>wincmd h<CR>", opts)
map("t", "<A-j>", "<Cmd>wincmd j<CR>", opts)
map("t", "<A-k>", "<Cmd>wincmd k<CR>", opts)
map("t", "<A-l>", "<Cmd>wincmd l<CR>", opts)
