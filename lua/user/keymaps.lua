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

map("n", "ZZ", ":wqa<CR>", opts)
map("n", "ZQ", ":qa!<CR>", opts)

local have_nvtree, nvtree = pcall(require, 'nvim-tree.api')
if have_nvtree then
	map("n", "<leader>e", nvtree.tree.toggle, opts)
else
	map("n", "<leader>e", ":Lex 20<CR>", opts)
end
map("n", "<leader>s", ":set hls!<CR>", opts)
map("n", "<leader>w", ":set wrap!<CR>", opts)

local have_telescope, telescope = pcall(require, 'telescope.builtin')
if have_telescope then
	map("n", "<leader>t", telescope.live_grep, opts)
	map("n", "<leader>T", function() telescope.live_grep({grep_open_files = true}) end, opts)
	map("n", "<leader>*", telescope.grep_string, opts)
	map("n", "<leader>f", telescope.find_files, opts)
	map("n", "<C-l>",     telescope.buffers, opts)
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
map("n", "<C-n>", ":bnext<CR>", opts)
map("n", "<C-p>", ":bprevious<CR>", opts)


-- Insert -----------------------------------------------------------------------------
-- Move text up/down while in insert mode
map("i", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
map("i", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)


-- Visual -----------------------------------------------------------------------------
-- Stay in indent mode
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Move text up and down
map("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
map("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)

-- Overwrite paste
map("v", "p", '"_dp', opts)


-- Terminal ---------------------------------------------------------------------------
map("n", "<leader>`", ":split+terminal<CR>", opts)

-- Window switch from terminal
map("t", "<A-h>", "<C-\\><C-n><C-w>h", opts)
map("t", "<A-j>", "<C-\\><C-n><C-w>j", opts)
map("t", "<A-k>", "<C-\\><C-n><C-w>k", opts)
map("t", "<A-l>", "<C-\\><C-n><C-w>l", opts)
