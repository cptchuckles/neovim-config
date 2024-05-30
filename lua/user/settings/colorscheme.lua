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
      \|  highlight! link Whitespace Comment
      \|  highlight! Whitespace cterm=NONE ctermbg=NONE gui=NONE guibg=NONE
      \|  highlight! link WinSeparator LineNr
      \|  highlight! GitSignsCurrentLineBlame cterm=italic,bold ctermfg=Lightgray gui=italic,bold guifg=#4A4A4A
      \|  highlight! DiagnosticVirtualTextError cterm=bold,italic gui=bold,italic ctermfg=darkred guifg=darkred guibg=NONE
      \|  highlight! DiagnosticVirtualTextWarn cterm=bold,italic gui=bold,italic ctermfg=yellow guifg=#777700 guibg=NONE
      \|  highlight! DiagnosticVirtualTextInfo cterm=bold,italic gui=bold,italic ctermfg=lightyellow guifg=#666644 guibg=NONE
      \|  highlight! link IndentBlanklineSpaceChar Whitespace
      \|  highlight! IndentBlanklineIndent2 guibg=NONE gui=nocombine
      \|  highlight! link IlluminatedWordText LspReferenceText
      \|  highlight! link IlluminatedWordRead LspReferenceRead
      \|  highlight! link IlluminatedWordWrite LspReferenceWrite
      \|  let g:clear_colorscheme = 0
    augroup end
  ]]
end

vim.api.nvim_create_user_command("ClearColorscheme", function(opts)
  vim.cmd(string.format("colorscheme %s", opts.fargs[1] or vim.g.colors_name))

  vim.g.clear_colorscheme = 1

  for _, group in ipairs(vim.fn.getcompletion("Git", "highlight")) do
    vim.cmd("hi " .. group .. " guibg=NONE")
  end
  for _, group in ipairs(vim.fn.getcompletion("Diff", "highlight")) do
    vim.cmd("hi " .. group .. " guibg=NONE")
  end

  vim.cmd([[
    hi Normal guibg=NONE
    hi NormalNC guibg=NONE
    hi EndOfBuffer guibg=NONE
    hi NormalFloat guibg=NONE
    hi FloatBorder guibg=NONE
    hi FloatWinBorder guibg=NONE
    hi ColorColumn guibg=NONE
    hi SignColumn guibg=NONE
    hi NvimTreeNormal guibg=NONE
    hi NvimTreeNormalNC guibg=NONE
    hi NvimTreeWinSeparator guibg=NONE
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
