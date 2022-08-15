local opts = { noremap = true, silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

-- Remap leader key
keymap("", "\\", "<Nop>", opts)
vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"


-- Normal -----------------------------------------------------------------------------
-- Better window navigation
keymap("n", "<M-h>", "<C-w>h", opts)
keymap("n", "<M-j>", "<C-w>j", opts)
keymap("n", "<M-k>", "<C-w>k", opts)
keymap("n", "<M-l>", "<C-w>l", opts)

keymap("n", "ZZ", ":wqa<CR>", opts)
keymap("n", "ZQ", ":qa!<CR>", opts)

keymap("n", "<leader>e", ":Lex 30<CR>", opts)
keymap("n", "<leader>s", ":set hls!<CR>", opts)

keymap("n", "<leader>t", "<cmd>Telescope live_grep<cr>", opts)
keymap("n", "<leader>f", "<cmd>lua require('telescope.builtin').find_files()<cr>", opts)

-- Window resizing with CTRL-Arrowkey
keymap("n", "<C-Up>", "2<C-w>-", opts)
keymap("n", "<C-Down>", "2<C-w>+", opts)
keymap("n", "<C-Left>", "2<C-w><", opts)
keymap("n", "<C-Right>", "2<C-w>>", opts)

-- Navigate buffers
keymap("n", "<C-n>", ":bnext<CR>", opts)
keymap("n", "<C-p>", ":bprevious<CR>", opts)


-- Insert -----------------------------------------------------------------------------
-- Move text up/down while in insert mode
keymap("i", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
keymap("i", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)


-- Visual -----------------------------------------------------------------------------
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)

-- Overwrite paste
keymap("v", "p", '"_dp', opts)


-- Terminal ---------------------------------------------------------------------------
keymap("n", "<leader>`", ":split+terminal<CR>", opts)

-- Window switch from terminal
keymap("t", "<A-h>", "<C-\\><C-n><C-w>h", opts)
keymap("t", "<A-j>", "<C-\\><C-n><C-w>j", opts)
keymap("t", "<A-k>", "<C-\\><C-n><C-w>k", opts)
keymap("t", "<A-l>", "<C-\\><C-n><C-w>l", opts)
