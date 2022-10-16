local M = {}

local function make_theme_augroup()
  vim.cmd [[
    augroup ColorSchemeOverride
      au!
      au ColorScheme *
      \   highlight! TabLineFill cterm=NONE gui=NONE ctermbg=Darkgray guibg=#333333
      \|  highlight! Todo cterm=bold gui=bold ctermbg=Yellow ctermfg=Black guibg=Yellow guifg=Black
      \|  highlight! Comment cterm=italic gui=italic
      \|  highlight! TSComment cterm=italic gui=italic guifg=#505060
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
      \|  highlight! link NvimTreeIndentMarker TSComment
    augroup end
  ]]
end

---@class colorschemeOptions
---@field public scheme string?

---@param opts colorschemeOptions
M.setup = function(opts)
  opts = opts or {}
  opts.scheme = opts.scheme or 'default'
  make_theme_augroup()
  vim.api.nvim_command('colorscheme ' .. opts.scheme)
end

return M
