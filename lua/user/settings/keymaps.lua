-- Utility functions

local function map(mode, lhs, rhs, opts)
	opts = opts or { remap = false, silent = true}
	vim.keymap.set(mode, lhs, rhs, opts)
end

---https://github.com/tjdevries/lazy.nvim/blob/master/lua/lazy.lua#L64-L72
local function lazy_require_on_call(mod)
	return setmetatable({}, {
		__index = function(_, key)
			return function(...)
				return require(mod)[key](...)
			end
		end,
	})
end

-- Remap leader key
map('', '\\', [[<Nop>]])
vim.g.mapleader = '\\'
vim.g.maplocalleader = '\\'


-- Normal -----------------------------------------------------------------------------
-- Better window navigation
map('n', "<A-h>", [[<C-w>h]])
map('n', "<A-j>", [[<C-w>j]])
map('n', "<A-k>", [[<C-w>k]])
map('n', "<A-l>", [[<C-w>l]])

-- Bbye commands
map('n', "<C-q>", [[<Cmd>Bdelete<CR>]])

-- Formatting
map('n', "<leader>F", [[<Cmd>Format<CR>]])

map('n', "ZZ", [[:wqa<CR>]])
map('n', "ZQ", [[:qa!<CR>]])

map('n', "<leader>e", function()
	if not pcall(function() require('nvim-tree.api').tree.toggle() end) then
		vim.api.nvim_command [[Lex 30]]
	end
end)
map('n', "<leader>E", [[<Cmd>SymbolsOutline<CR>]])
map('n', "<leader>s", [[<Cmd>set hls!<CR>]])
map('n', "<leader>w", [[<Cmd>set wrap!<CR>]])

local lazyscope = lazy_require_on_call 'telescope.builtin'
map('n', "<leader>ta", lazyscope.live_grep)
map('n', "<leader>to", function() lazyscope.live_grep { grep_open_files = true } end)
map('n', "<leader>*" , lazyscope.grep_string)
map('n', "<leader>tf", lazyscope.find_files)
map('n', "<leader>ts", lazyscope.treesitter)
map('n', "<leader>qh", lazyscope.quickfixhistory)
map('n', "<leader>rg", lazyscope.current_buffer_fuzzy_find)
map('n', "<leader>tt", lazyscope.resume)
map('n', "<C-l>", function()
	if not pcall(function() lazyscope.buffers() end) then
		-- This is the kind of stupid shit I have to go through just to emulate keypresses
		local cmdstr = vim.api.nvim_replace_termcodes(":ls<CR>:b", true, false, true)
		vim.api.nvim_feedkeys(cmdstr, 'n', false)
	end
end)

map('n', "<leader>gg", [[<Cmd>LazyGit<CR>]])

-- Window resizing with CTRL-Arrowkey
map('n', "<C-Up>"   , [[2<C-w>-]])
map('n', "<C-Down>" , [[2<C-w>+]])
map('n', "<C-Left>" , [[2<C-w><]])
map('n', "<C-Right>", [[2<C-w>>]])

-- Navigate buffers
map('n', "<C-n>", [[<Cmd>bnext<CR>]])
map('n', "<C-p>", [[<Cmd>bprev<CR>]])


-- Insert -----------------------------------------------------------------------------
-- Move text up/down while in insert mode
map('i', "<A-j>", [[<Cmd>m .+1<CR><C-o>==]])
map('i', "<A-k>", [[<Cmd>m .-2<CR><C-o>==]])


-- Visual -----------------------------------------------------------------------------
-- Stay in indent mode
map('v', "<", [[<gv]])
map('v', ">", [[>gv]])

-- Move text up and down
map('v', "<A-j>", [[:m '>+1<CR>gv=gv]])
map('v', "<A-k>", [[:m '<-2<CR>gv=gv]])

-- Overwrite paste
map('v', "p", [["_dp]])
map('v', "P", [["_dP]])

-- Format selection
map({ 'v', 'x' }, '<leader>f', [[:FormatRange<CR>]])

-- Collimate on =
map({ 'v', 'x' }, '<leader>c', [[:!column --table -s= -o=<CR>]])


-- Terminal ---------------------------------------------------------------------------
map('n', "<leader>`", [[<Cmd>split+terminal<CR>]])

-- Window switch from terminal
map('t', "<A-h>", [[<Cmd>wincmd h<CR>]])
map('t', "<A-j>", [[<Cmd>wincmd j<CR>]])
map('t', "<A-k>", [[<Cmd>wincmd k<CR>]])
map('t', "<A-l>", [[<Cmd>wincmd l<CR>]])
