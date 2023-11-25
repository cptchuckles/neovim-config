local M = {}

local function make_theme_augroup()
  vim.cmd [[
    augroup ColorSchemeOverride
      au!
      au ColorScheme *
      \   highlight! TabLineFill cterm=NONE gui=NONE ctermbg=Darkgray guibg=#333333
      \|  highlight! Todo cterm=bold gui=bold ctermbg=Yellow ctermfg=Black guibg=Yellow guifg=Black
      \|  highlight! Comment cterm=italic gui=italic
      \|  highlight! link TSComment Comment
      \|  highlight! Whitespace cterm=NONE ctermfg=8 guifg=#3a3a3a
      \|  highlight! link WinSeparator LineNr
      \|  highlight! GitSignsCurrentLineBlame cterm=italic,bold ctermfg=Lightgray gui=italic,bold guifg=#4A4A4A
      \|  highlight! DiagnosticVirtualTextError cterm=bold,italic gui=bold,italic ctermfg=darkred guifg=darkred guibg=NONE
      \|  highlight! DiagnosticVirtualTextWarn cterm=bold,italic gui=bold,italic ctermfg=yellow guifg=#777700 guibg=NONE
      \|  highlight! DiagnosticVirtualTextInfo cterm=bold,italic gui=bold,italic ctermfg=lightyellow guifg=#666644 guibg=NONE
      \|  highlight! IndentBlanklineChar guifg=#2b2f38 gui=nocombine
      \|  highlight! link IndentBlanklineSpaceChar Whitespace
      \|  highlight! link IndentBlanklineIndent1 CursorColumn
      \|  highlight! IndentBlanklineIndent2 guibg=NONE gui=nocombine
      \|  highlight! link IlluminatedWordText LspReferenceText
      \|  highlight! link IlluminatedWordRead LspReferenceRead
      \|  highlight! link IlluminatedWordWrite LspReferenceWrite
    augroup end
  ]]
end

vim.api.nvim_create_user_command("ClearColorscheme", function(opts)
  local cmd_string = string.format("colorscheme %s", opts.fargs[1] or vim.g.colors_name)

  for _, group in ipairs(vim.fn.getcompletion("GitSigns", "highlight")) do
    cmd_string = cmd_string .. "\n \\| hi " .. group .. " guibg=NONE"
  end

  vim.cmd(cmd_string .. [[

    \| hi Normal guibg=NONE
    \| hi NormalNC guibg=NONE
    \| hi NormalFloat guibg=NONE
    \| hi FloatBorder guibg=NONE
    \| hi FloatWinBorder guibg=NONE
    \| hi ColorColumn guibg=NONE
    \| hi SignColumn guibg=NONE
    \| hi NvimTreeNormal guibg=NONE
    \| hi NvimTreeNormalNC guibg=NONE
    \| hi NvimTreeWinSeparator guibg=NONE
  ]])
end, { nargs = '?' })

---@class colorschemeOptions
---@field public scheme string?

---@param opts colorschemeOptions?
M.setup = function(opts)
  opts = opts or {}
  opts.scheme = opts.scheme or 'default'
  make_theme_augroup()
  vim.api.nvim_command('ClearColorscheme ' .. opts.scheme)
end

return M
