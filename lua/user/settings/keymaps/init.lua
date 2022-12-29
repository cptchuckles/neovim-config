-- Utility functions
local function map(mode, lhs, rhs, opts)
	opts = opts or {}
	opts = vim.tbl_extend('keep', opts, { remap = false, silent = true })
	vim.keymap.set(mode, lhs, rhs, opts)
end

local function get_visual_text()
	return vim.fn.strcharpart(
		vim.fn.getline(vim.fn.line('.')),
		vim.fn.min({
			vim.fn.charcol('.'),
			vim.fn.charcol('v'),
		}) - 1,
		vim.fn.abs(vim.fn.charcol('.') - vim.fn.charcol('v')) + 1
	)
end

-- Remap leader key
map('', '\\', [[<Nop>]])
vim.g.mapleader = '\\'
vim.g.maplocalleader = '\\'


-- Normal -----------------------------------------------------------------------------
-- Better window navigation
map('n', '<C-h>', [[<C-w>h]])
map('n', '<C-j>', [[<C-w>j]])
map('n', '<C-k>', [[<C-w>k]])
map('n', '<C-l>', [[<C-w>l]])

-- Center view after page up/down
-- map('n', '<C-d>', [[<C-d>zz]])
-- map('n', '<C-u>', [[<C-u>zz]])
-- map('n', '<C-f>', [[<C-f>zz]])
-- map('n', '<C-b>', [[<C-b>zz]])

-- Fast scrolling
map('n', '<C-e>', [[3<C-e>]])
map('n', '<C-y>', [[3<C-y>]])

-- Move lines
map('n', '<A-j>', [[<Cmd>move .+1<CR>==]])
map('n', '<A-k>', [[<Cmd>move .-2<CR>==]])

-- Bbye commands
map('n', '<C-q>', [[<Cmd>Bdelete<CR>]])

map('n', 'ZZ', [[:wqa<CR>]])
map('n', 'ZQ', [[:qa!<CR>]])

map('n', '<leader>e', function()
	if not pcall(function() require('nvim-tree.api').tree.toggle() end) then
		vim.api.nvim_command [[Lex 30]]
	end
end, { desc = "Open nvim-tree or :Lexplore if it isn't found" })
map('n', '<leader>E', [[<Cmd>SymbolsOutline<CR>]])
map('n', '<leader>s', [[<Cmd>set hls!<CR>]])
map('n', '<leader>w', [[<Cmd>set wrap!<CR>]])

local lazyscope = require('lazy-require').require_on_exported_call('telescope.builtin')
map('n', '<leader>ta', lazyscope.live_grep, { desc = "Telescope live-grep all files" })
map('n', '<leader>to', function() lazyscope.live_grep { grep_open_files = true } end, {
	desc = "Telescope live-grep only open buffers",
})
map('n', '<leader>*', lazyscope.grep_string, { desc = "Telescope grep symbol under cursor" })
map('x', '<leader>*', function()
	lazyscope.grep_string { search = get_visual_text() }
end, { desc = "Telescope grep highlighted text" })
map('n', '<leader>tf', lazyscope.find_files,                { desc = "Telescope fuzzy-search for files" })
map('n', '<leader>ts', lazyscope.treesitter,                { desc = "Telescope list treesitter symbols in buffer" })
map('n', '<leader>tq', lazyscope.quickfixhistory,           { desc = "Telescope list quickfix history" })
map('n', '<leader>rg', lazyscope.current_buffer_fuzzy_find, { desc = "Telescope grep inside current buffer" })
map('n', '<leader>tt', lazyscope.resume,                    { desc = "Telescope resume last session" })
map('n', '<A-l>', function()
	if not pcall(function() lazyscope.buffers() end) then
		vim.api.nvim_command [[ls]]
		vim.api.nvim_feedkeys(":b", 'n', false)
	end
end, { desc = "List open buffers in telescope, or with :ls if telescope can't be loaded" })

map('n', '<leader>gg', [[<Cmd>LazyGit<CR>]])

-- DAP
local lazydap = require('lazy-require').require_on_exported_call 'dap'
map('n', '<F5>', lazydap.continue,                { desc = "DAP continue" })
map('n', '<F10>', lazydap.step_over,              { desc = "DAP step over" })
map('n', '<F11>', lazydap.step_into,              { desc = "DAP step into" })
map('n', '<F12>', lazydap.step_out,               { desc = "DAP step out" })
map('n', '<leader>db', lazydap.toggle_breakpoint, { desc = "DAP toggle breakpoint" })
map('n', '<leader>dB', function() lazydap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
	{ desc = "DAP set a breakpoint condition" })
map('n', '<leader>dL', function() lazydap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end,
	{ desc = "DAP set log point message" })
map('n', '<leader>dR', function() require('dap').repl.open() end, { desc = "DAP open repl" })

-- Window resizing with CTRL-Arrowkey
map('n', '<C-Up>'   , [[2<C-w>-]])
map('n', '<C-Down>' , [[2<C-w>+]])
map('n', '<C-Left>' , [[2<C-w><]])
map('n', '<C-Right>', [[2<C-w>>]])

-- Navigate buffers
map('n', '<C-n>', [[<Cmd>bnext<CR>]])
map('n', '<C-p>', [[<Cmd>bprev<CR>]])

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
local function collimate()
	vim.fn.inputsave()
	local delimiter = vim.fn.input("Collimate on: ", '=')
	vim.fn.inputrestore()
	if #delimiter < 1 then
		return
	end
	local cr = vim.api.nvim_replace_termcodes('<cr>', true, false, true)
	delimiter:gsub('[^%d%s]%d*', function(d)
		local l = #d > 1 and (' -l' .. d:sub(2)) or ''
		local ch = d:sub(1, 1):gsub('[\'\\"<>&|();#]', function(s) return '\\' .. s end)
		local cmd = 'gv:!column -t ' .. l .. ' -s' .. ch .. ' -o' .. ch .. cr
		vim.api.nvim_feedkeys(cmd, 'n', false)
	end)
end
vim.api.nvim_create_user_command("Collimate", collimate, { range = '%' })
map('x', '<leader>c', [[:Collimate<CR>]])

-- Replace text command
local function replace_all()
	local query = get_visual_text()
	vim.fn.inputsave()
	local answer = vim.fn.input("Replace text: ", query)
	vim.api.nvim_command(
		'%s/\\V' .. query:gsub('/', '\\/') .. '/' .. answer:gsub('/', '\\/') .. '/ge'
	)
	vim.fn.inputrestore()
	vim.api.nvim_feedkeys('v', 'n', false)
end
map('x', '<C-r>', replace_all, { desc = "Replace all selected text in buffer" })

-- Terminal ---------------------------------------------------------------------------
map('n', '<leader>`', [[<Cmd>botright split+terminal<CR>]])

-- Window switch from terminal
map('t', '<A-Esc>', [[<Cmd>stopinsert<CR>]])

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
	[']b']         = function() bl.cycle(1) end,
	['<A-1>']      = function() bl.go_to(1, false) end,
	['<A-2>']      = function() bl.go_to(2, false) end,
	['<A-3>']      = function() bl.go_to(3, false) end,
	['<A-4>']      = function() bl.go_to(4, false) end,
	['<A-5>']      = function() bl.go_to(5, false) end,
	['<A-6>']      = function() bl.go_to(6, false) end,
	['<A-7>']      = function() bl.go_to(7, false) end,
	['<A-8>']      = function() bl.go_to(8, false) end,
	['<A-9>']      = function() bl.go_to(-1, true) end,
	['<A-0>']      = function() bl.go_to(1, true) end,
}

M.gitsigns  = require('user.settings.keymaps.gitsigns')
M.lsp_setup = require('user.settings.keymaps.lsp')
M.telescope = require('user.settings.keymaps.telescope')

M.indent_blankline = function()
	local zmaps = {
		'zA', 'zC', 'zD', 'zE', 'zM', 'zN', 'zO', 'zR',
		'za', 'zc', 'zd', 'zi', 'zm', 'zn', 'zo', 'zr', 'zv', 'zx',
	}
	for _, lhs in ipairs(zmaps) do
		vim.keymap.set('n', lhs, function()
			vim.api.nvim_feedkeys(lhs, 'n', false)
			vim.schedule(vim.F.nil_wrap(function() require('indent_blankline').refresh() end))
		end, { desc = "Refresh IndentBlankline after fold operation", remap = false, silent = true })
	end
end

return M
