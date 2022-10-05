-- Utility functions
local function map(mode, lhs, rhs, opts)
	opts = opts or {}
	opts = vim.tbl_extend('keep', opts, { remap = false, silent = true })
	vim.keymap.set(mode, lhs, rhs, opts)
end

-- Remap leader key
map('', '\\', [[<Nop>]])
vim.g.mapleader = '\\'
vim.g.maplocalleader = '\\'


-- Normal -----------------------------------------------------------------------------
-- Better window navigation
map('n', '<A-h>', [[<C-w>h]])
map('n', '<A-j>', [[<C-w>j]])
map('n', '<A-k>', [[<C-w>k]])
map('n', '<A-l>', [[<C-w>l]])

-- Center view after page up/down
-- map('n', '<C-d>', [[<C-d>zz]])
-- map('n', '<C-u>', [[<C-u>zz]])
-- map('n', '<C-f>', [[<C-f>zz]])
-- map('n', '<C-b>', [[<C-b>zz]])

-- Fast scrolling
map('n', '<C-e>', [[3<C-e>]])
map('n', '<C-y>', [[3<C-y>]])

-- Move lines
map('n', '<C-j>', [[<Cmd>move .+1<CR>==]])
map('n', '<C-k>', [[<Cmd>move .-2<CR>==]])

-- Bbye commands
map('n', '<C-q>', [[<Cmd>Bdelete<CR>]])

map('n', 'ZZ', [[:wqa<CR>]])
map('n', 'ZQ', [[:qa!<CR>]])

map('n', '<leader>e', function()
	if not pcall(function() require('nvim-tree.api').tree.toggle() end) then
		vim.api.nvim_command [[Lex 30]]
	end
end)
map('n', '<leader>E', [[<Cmd>SymbolsOutline<CR>]])
map('n', '<leader>s', [[<Cmd>set hls!<CR>]])
map('n', '<leader>w', [[<Cmd>set wrap!<CR>]])

local lazyscope = require('lazy').require_on_exported_call('telescope.builtin')
map('n', '<leader>ta', lazyscope.live_grep)
map('n', '<leader>to', function() lazyscope.live_grep { grep_open_files = true } end)
map('n', '<leader>*' , lazyscope.grep_string)
map('n', '<leader>tf', lazyscope.find_files)
map('n', '<leader>ts', lazyscope.treesitter)
map('n', '<leader>qh', lazyscope.quickfixhistory)
map('n', '<leader>rg', lazyscope.current_buffer_fuzzy_find)
map('n', '<leader>tt', lazyscope.resume)
map('n', '<C-l>', function()
	if not pcall(function() lazyscope.buffers() end) then
		-- This is the kind of stupid shit I have to go through just to emulate keypresses
		local cmdstr = vim.api.nvim_replace_termcodes(':ls<CR>:b', true, false, true)
		vim.api.nvim_feedkeys(cmdstr, 'n', false)
	end
end)

map('n', '<leader>gg', [[<Cmd>LazyGit<CR>]])

-- DAP
local lazydap = require('lazy').require_on_exported_call 'dap'
map('n', '<F5>', lazydap.continue)
map('n', '<F10>', lazydap.step_over)
map('n', '<F11>', lazydap.step_into)
map('n', '<F12>', lazydap.step_out)
map('n', '<leader>db', lazydap.toggle_breakpoint)
map('n', '<leader>dB', function() lazydap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end)
map('n', '<leader>dL', function() lazydap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
map('n', '<leader>dR', function() require('dap').repl.open() end)

-- Window resizing with CTRL-Arrowkey
map('n', '<C-Up>'   , [[2<C-w>-]])
map('n', '<C-Down>' , [[2<C-w>+]])
map('n', '<C-Left>' , [[2<C-w><]])
map('n', '<C-Right>', [[2<C-w>>]])

-- Navigate buffers
map('n', '<C-n>', [[<Cmd>bnext<CR>]])
map('n', '<C-p>', [[<Cmd>bprev<CR>]])


-- Insert -----------------------------------------------------------------------------
-- Move text up/down while in insert mode
map('i', '<A-j>', [[<Cmd>move .+1<CR><C-o>==]])
map('i', '<A-k>', [[<Cmd>move .-2<CR><C-o>==]])


-- Visual -----------------------------------------------------------------------------
-- Stay in indent mode
map('v', '<', [[<gv]])
map('v', '>', [[>gv]])

-- Move text up and down
map('v', '<A-j>', [[:move '>+1<CR>gv=gv]])
map('v', '<A-k>', [[:move '<-2<CR>gv=gv]])

-- Overwrite paste
map('v', 'p', [["vdp]])
map('v', 'P', [["vdP]])

-- Collimate
vim.api.nvim_create_user_command("Collimate", function()
	vim.fn.inputsave()
	local delimiter = vim.fn.input("Collimate on: ", '=')
	vim.fn.inputrestore()
	if #delimiter < 1 then
		return
	end
	local cr = vim.api.nvim_replace_termcodes('<cr>', true, false, true)
	delimiter:gsub('[^%d%s]%d*', function(d)
		local l = #d > 1 and (' -l' .. d:sub(2)) or ''
		local ch = d:sub(1,1):gsub('[\'\\"<>&|]', function(s) return '\\' .. s end)
		local cmd = 'gv:!column -t ' .. l .. ' -s' .. ch .. ' -o' .. ch .. cr
		vim.api.nvim_feedkeys(cmd, 'n', false)
	end)
end, { range = '%' })
map('x', '<leader>c', [[:Collimate<CR>]])

-- Replace text command
map('x', '<C-r>', function()
	local query = vim.fn.strcharpart(
		vim.fn.getline(vim.fn.line('.')),
		vim.fn.min({
			vim.fn.charcol('.'),
			vim.fn.charcol('v'),
		}) - 1,
		vim.fn.abs(vim.fn.charcol('.') - vim.fn.charcol('v')) + 1
	)

	vim.fn.inputsave()
	local answer = vim.fn.input("Replace text: ", query)
	vim.api.nvim_command(
		'%s/\\V' .. query:gsub('/','\\/') .. '/' .. answer:gsub('/','\\/') .. '/ge'
	)
	vim.fn.inputrestore()
	vim.api.nvim_feedkeys('v', 'n', false)
end)

-- Terminal ---------------------------------------------------------------------------
map('n', '<leader>`', [[<Cmd>split+terminal<CR>]])

-- Window switch from terminal
map('t', '<A-h>', [[<Cmd>wincmd h<CR>]])
map('t', '<A-j>', [[<Cmd>wincmd j<CR>]])
map('t', '<A-k>', [[<Cmd>wincmd k<CR>]])
map('t', '<A-l>', [[<Cmd>wincmd l<CR>]])


-- Plugin keybinds --------------------------------------------------------------------
local M = {}

M.symbols_outline = {
	close          = { '<Esc>', 'q' },
	goto_location  = '<CR>',
	focus_location = '<Tab>',
	hover_symbol   = '<Space>',
	toggle_preview = 'K',
	rename_symbol  = 'r',
	code_actions   = 'a',
	fold           = 'h',
	unfold         = 'l',
	fold_all       = 'W',
	unfold_all     = 'E',
	fold_reset     = 'R',
}

M.nvim_tree = {
	['[d'] = function() require('nvim-tree.api').node.navigate.diagnostics.prev() end,
	[']d'] = function() require('nvim-tree.api').node.navigate.diagnostics.next() end,
}

local bl = require('lazy').require_on_exported_call('bufferline')
M.bufferline = {
	['<leader>bq'] = bl.close_with_pick,
	['<leader>bb'] = bl.pick_buffer,
	['[b']         = function() bl.cycle(-1) end,
	[']b']         = function() bl.cycle( 1) end,
	['<A-1>']      = function() bl.go_to(1, false) end,
	['<A-2>']      = function() bl.go_to(2, false) end,
	['<A-3>']      = function() bl.go_to(3, false) end,
	['<A-4>']      = function() bl.go_to(4, false) end,
	['<A-5>']      = function() bl.go_to(5, false) end,
	['<A-6>']      = function() bl.go_to(6, false) end,
	['<A-7>']      = function() bl.go_to(7, false) end,
	['<A-8>']      = function() bl.go_to(8, false) end,
	['<A-9>']      = function() bl.go_to(-1, true) end,
	['<A-0>']      = function() bl.go_to( 1, true) end,
}

M.gitsigns   = require('user.settings.keymaps.gitsigns')
M.lsp_setup  = require('user.settings.keymaps.lsp')
M.telescope  = require('user.settings.keymaps.telescope')

return M
