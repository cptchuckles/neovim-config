local status_ok, gl = pcall(require, 'galaxyline')
if not status_ok then
	print("Couldn't load 'galaxyline'")
	return
end

local colors = require('galaxyline.theme').default
local condition = require('galaxyline.condition')

gl.short_line_list = { 'NvimTree', 'Outline', 'Trouble', 'qf', }

colors.green    = "#118822"
colors.blue     = "#4466aa"
colors.red      = "#aa4422"
colors.grayblue = "#283034"
colors.gray     = "#767676"
colors.none = function()
	local sl = vim.api.nvim_get_hl_by_name('StatusLine', true)
	local color = sl.reverse and sl.foreground or sl.background
	return color and string.format("#%x", color) or "NONE"
end

local function buffer_not_empty()
	return #vim.fn.expand('%:t') > 0
end

---@param width integer
local function window_wider_than(width)
	return vim.fn.winwidth(0) >= width
end

---@param width integer
local function can_show_git_at(width)
	return function()
		return buffer_not_empty() and window_wider_than(width) and condition.check_git_workspace()
	end
end

local sections = { left = 0, mid = 0, right = 0, short_line_left = 0, short_line_right = 0, }
local function section(pos, tbl)
	sections[pos] = sections[pos] + 1
	gl.section[pos][sections[pos]] = tbl
end

--- Defines the highlight colors for a section of GalaxyLine
---@class VimMode
---@field text string?
---@field fg string
---@field bg string

local modes = {
	n       = { text = "NORMAL", fg = colors.bg, bg = colors.yellow, },      ---@type VimMode
	i       = { text = "INSERT", bg = colors.green, },                       ---@type VimMode
	v       = { text = "VISUAL", bg = colors.blue, },                        ---@type VimMode
	V       = { text = "VISUAL-LINE", bg = colors.blue, },                   ---@type VimMode
	['']  = { text = "VISUAL-BLOCK", bg = colors.blue, },                  ---@type VimMode
	S       = { text = "SELECT-LINE", bg = colors.red, },                    ---@type VimMode
	['']  = { text = "SELECT-BLOCK", bg = colors.red, },                   ---@type VimMode
	c       = { text = "COMMAND", fg = colors.bg, bg = colors.blue, },       ---@type VimMode
	R       = { text = "REPLACE", bg = colors.red, },                        ---@type VimMode
	r       = { text = "PRESS ENTER", fg = colors.bg, bg = colors.green, },  ---@type VimMode
	t       = { text = "TERMINAL", fg = colors.bg, bg = colors.red, },       ---@type VimMode
	default = { text = nil, fg = colors.bg, bg = colors.red, },              ---@type VimMode
}
for m, _ in pairs(modes) do
	modes[m] = vim.tbl_extend("keep", modes[m], { fg = colors.fg, bg = colors.bg })
end

local function ViModeLeftSection()
	---@type VimMode
	local vimode = modes.n

	section('left', {
		Vim = {
			provider = function() return ' ' end,
			highlight = { colors.green, colors.bg },
		}
	})
	section('left', {
		VimSeparator = {
			provider = function()
				vimode = modes[vim.fn.mode()] or modes.default
				vim.api.nvim_command('hi GalaxyVimSeparator guifg=' .. colors.bg .. ' guibg=' .. vimode.bg)
				return ' '
			end,
		}
	})
	section('left', {
		ViMode = {
			provider = function()
				vim.api.nvim_command('hi GalaxyViMode gui=BOLD guifg=' .. vimode.fg .. ' guibg=' .. vimode.bg)
				return vimode.text or vim.fn.mode(1)
			end,
		}
	})
	section('left', {
		ViModeSeparator = {
			provider = function()
				local bgcolor = (buffer_not_empty() and condition.check_git_workspace()) and colors.bg or colors.none()
				vim.api.nvim_command('hi GalaxyViModeSeparator guifg=' .. vimode.bg .. ' guibg=' .. bgcolor)
				return ' '
			end,
		}
	})
end
ViModeLeftSection()

section('left', {
	GitBranch = {
		condition = can_show_git_at(60),
		provider = function()
			return require('galaxyline.provider_vcs').get_git_branch()
		end,
		icon = '  ',
		highlight = { colors.orange, colors.bg },
		separator = ' ',
		separator_highlight = { colors.bg, colors.none },
	}
})
local function GitChanges()
	local vcs = require('galaxyline.provider_vcs')
	section('left', {
		GitDiffs = {
			condition = can_show_git_at(90),
			provider = function()
				local diffs = vcs.diff_modified()
				return (diffs and '~'..diffs or '')
			end,
			highlight = { colors.blue, colors.none },
		}
	})
	section('left', {
		GitAdds = {
			condition = can_show_git_at(90),
			provider = function()
				local adds = vcs.diff_add()
				return (adds and '+'..adds or '')
			end,
			highlight = { colors.green, colors.none },
		}
	})
	section('left', {
		GitRems = {
			condition = can_show_git_at(90),
			provider = function()
				local rems = vcs.diff_remove()
				return (rems and '-'..rems or '')
			end,
			highlight = { colors.red, colors.none },
		}
	})
end
GitChanges()

section('mid', {
	FileInformationPre = {
		condition = buffer_not_empty,
		provider = function() return '' end,
		highlight = { colors.grayblue, colors.none },
	}
})
section('mid', {
	FileIcon = {
		condition = buffer_not_empty,
		provider = 'FileIcon',
		highlight = { require('galaxyline.provider_fileinfo').get_file_icon_color, colors.grayblue },
	}
})
section('mid', {
	FileName = {
		condition = buffer_not_empty,
		provider = function()
			return vim.fn.expand('%:.') .. ' '
		end,
		highlight = { colors.fg, colors.grayblue, },
	}
})
section('mid', {
	FileModified = {
		condition = buffer_not_empty,
		provider = function() return vim.bo.modified and 'פֿ ' or '' end,
		highlight = { colors.yellow, colors.grayblue },
	}
})
section('mid', {
	FileReadOnly = {
		condition = function() return buffer_not_empty() and vim.bo.readonly end,
		provider = function() return '' end,
		separator = ' ',
		highlight = { colors.red, colors.grayblue },
		separator_highlight = { colors.red, colors.grayblue },
	}
})

local function LspMidSection()
	local lsp_active = false
	section('mid', {
		LspServerSeparator = {
			condition = function() return window_wider_than(75) and buffer_not_empty() end,
			provider = function()
				lsp_active = next(vim.lsp.buf_get_clients()) ~= nil
				return lsp_active and ' ' or ''
			end,
			highlight = { colors.none, colors.grayblue, 'bold' },
		}
	})
	section('mid', {
		LspServerName = {
			condition = function() return window_wider_than(75) and buffer_not_empty() end,
			provider = function()
				return lsp_active and require('galaxyline.provider_lsp').get_lsp_client() or ''
			end,
			icon = ' ',
			highlight = { colors.violet, colors.grayblue },
		}
	})
end
LspMidSection()

section('mid', {
	FileInformationPost = {
		condition = buffer_not_empty,
		provider = function() return ' ' end,
		highlight = { colors.grayblue, colors.none },
	}
})

local function Diagnostics()
	local diagnostics = {}
	section('mid', {
		DiagnosticErrors = {
			condition = function() return window_wider_than(60) and buffer_not_empty() end,
			provider = function()
				diagnostics = vim.diagnostic.get(0)
				local errors = vim.tbl_filter(function(d)
					return d.severity == vim.diagnostic.severity.ERROR
				end, diagnostics)
				if #errors > 0 then
					return ' ' .. #errors .. ' '
				end
				return ''
			end,
			highlight = { colors.red, colors.none, },
		}
	})
	section('mid', {
		DiagnosticWarnings = {
			condition = function() return window_wider_than(60) and buffer_not_empty() end,
			provider = function()
				local warnings = vim.tbl_filter(function(d)
					return d.severity == vim.diagnostic.severity.WARN
				end, diagnostics)
				if #warnings > 0 then
					return ' ' .. #warnings .. ' '
				end
				return ''
			end,
			highlight = { colors.orange, colors.none, },
		}
	})
	section('mid', {
		DiagnosticInfo = {
			condition = function() return window_wider_than(60) and buffer_not_empty() end,
			provider = function()
				local info = vim.tbl_filter(function(d)
					return d.severity == vim.diagnostic.severity.INFO
				end, diagnostics)
				if #info > 0 then
					return ' ' .. #info .. ' '
				end
				return ''
			end,
			highlight = { colors.violet, colors.none, },
		}
	})
	section('mid', {
		DiagnosticHints = {
			condition = function() return window_wider_than(60) and buffer_not_empty() end,
			provider = function()
				local hints = vim.tbl_filter(function(d)
					return d.severity == vim.diagnostic.severity.HINT
				end, diagnostics)
				if #hints > 0 then
					return 'ﯧ ' .. #hints .. ' '
				end
				return ''
			end,
			highlight = { colors.gray, colors.none, },
		}
	})
end
Diagnostics()

section('right', {
	Indentation = {
		condition = function()
			return buffer_not_empty() and vim.bo.buftype ~= 'terminal'
		end,
		provider = function()
			return (vim.bo.expandtab and ('·'..vim.bo.shiftwidth) or 'ﬀ') .. ' '
		end,
		highlight = { colors.gray, colors.none, },
	}
})
section('right', {
	FileFormat = {
		condition = buffer_not_empty,
		provider = function()
			return ({
				unix = ' ',
				dos = ' ',
			})[vim.bo.fileformat]
		end,
		highlight = { colors.fg, colors.bg, },
		separator = "",
		separator_highlight = { colors.bg, colors.none },
	}
})
section('right', {
	FileTypeName = {
		condition = function()
			return buffer_not_empty() and vim.bo.buftype ~= 'terminal'
		end,
		provider = function() return vim.bo.filetype end,
		highlight = { colors.fg, colors.bg, 'italic' },
		separator = " ",
		separator_highlight = { colors.none, colors.bg, 'bold' },
	}
})
section('right', {
	FileSize = {
		condition = function()
			return buffer_not_empty() and vim.bo.buftype ~= 'terminal' and window_wider_than(60)
		end,
		provider = 'FileSize',
		highlight = { colors.fg, colors.bg, },
		separator = "  ",
		separator_highlight = { colors.none, colors.bg, 'bold' },
	}
})
section('right', {
	CurPos = {
		provider = function()
			return " " .. vim.fn.line('.') .. ":" .. vim.fn.col('.')
		end,
		highlight = { colors.fg, colors.bg, 'bold' },
		separator = " ",
		separator_highlight = { colors.fg, colors.bg },
	}
})

local function shortlines()
	section("short_line_left", {
		ShortFiletype = {
			condition = function() return vim.bo.buftype == 'nofile' end,
			provider = function() return vim.bo.filetype end,
			highlight = { colors.none, colors.gray },
			separator = ' ',
			separator_highlight = { colors.gray, colors.bg },
		}
	})
	section("short_line_left", {
		ShortFileName = {
			condition = function() return vim.bo.buftype ~= 'nofile' end,
			provider = function() return vim.fn.expand("%:.:p") end,
			highlight = { colors.none, colors.gray },
			separator = ' ',
			separator_highlight = { colors.gray, colors.bg },
		}
	})
end
shortlines()
