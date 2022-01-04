local opt = vim.opt
local g = vim.g

g.did_load_filetypes = 1
g.sandwich_no_default_key_mappings = 1

g.mapleader = ' '
g.tokyonight_style = "night"
g.tokyonight_transparent = true
-- g.tokyonight_colors = { fg_gutter = "#ffba00" }

opt.encoding = 'utf-8'
opt.fileencoding = 'utf-8'
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 2
opt.expandtab = true
opt.list = true
opt.listchars = {tab='↦˙', eol='↲', nbsp='␣', trail='•', extends='⟩', precedes='⟨'}
opt.cursorline = true
opt.number = true
opt.relativenumber = true
opt.wrap = false
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = false
opt.background = "dark"
opt.signcolumn = "no"
opt.fixendofline = false

-- Programs
opt.grepprg = 'rg --vimgrep --smart-case --follow'
opt.clipboard:prepend('unnamedplus')
opt.ignorecase = true
opt.smartcase = true

-- UNDO
opt.undodir = vim.fn.stdpath('config') .. '/undo'
opt.undofile = true

local status, result = pcall(require, 'impatient')
if not status then
  print('loading `impatient`: '..result)
end
--result.enable_profile()

require('plugins')
require('packer_compiled')

vim.cmd([[
  augroup init_colorscheme
    autocmd!
    autocmd ColorScheme *
      \ highlight LineNr guifg=#5081c0 | highlight CursorLineNR guifg=#ffba00
  "     \   hi Normal     ctermbg=NONE guibg=NONE
  "     \ | hi LineNr     ctermfg=grey guifg=grey
  "     \ | hi Pmenu      ctermbg=DarkGrey guibg=DarkGrey
  "     \ | hi MatchParen cterm=bold gui=bold ctermfg=magenta guifg=magenta ctermbg=black guibg=black
  augroup END
  highlight HopNextKey2 guifg=#1b9fbf

  augroup init_numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
  augroup END

  augroup init_Org
    autocmd!
    autocmd FileType org setlocal foldenable
  augroup END

  augroup init_Packer
    autocmd!
    autocmd BufWritePost plugins.lua source | PackerCompile
  augroup end

  augroup init_Term
    autocmd!
    autocmd TermOpen * setlocal scrollback=100000
  augroup end

  " add
  silent! map <unique> <C-s>a <Plug>(sandwich-add)

  " SANDWICH
  " delete
  silent! nmap <unique> <C-s>d <Plug>(sandwich-delete)
  silent! xmap <unique> <C-s>d <Plug>(sandwich-delete)
  silent! nmap <unique> <C-s>db <Plug>(sandwich-delete-auto)

  " replace
  silent! nmap <unique> <C-s>r <Plug>(sandwich-replace)
  silent! xmap <unique> <C-s>r <Plug>(sandwich-replace)
  silent! nmap <unique> <C-s>rb <Plug>(sandwich-replace-auto)

  " " auto
  " silent! omap <unique> ib <Plug>(textobj-sandwich-auto-i)
  " silent! xmap <unique> ib <Plug>(textobj-sandwich-auto-i)
  " silent! omap <unique> ab <Plug>(textobj-sandwich-auto-a)
  " silent! xmap <unique> ab <Plug>(textobj-sandwich-auto-a)

  " " query
  " silent! omap <unique> is <Plug>(textobj-sandwich-query-i)
  " silent! xmap <unique> is <Plug>(textobj-sandwich-query-i)
  " silent! omap <unique> as <Plug>(textobj-sandwich-query-a)
  " silent! xmap <unique> as <Plug>(textobj-sandwich-query-a)

  " VSNIP
  " Expand
  imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
  smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'

  " Expand or jump
  imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
  smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

  " Jump forward or backward
  imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
  smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
  imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
  smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
]])

local map = vim.api.nvim_set_keymap
map('t', '<Esc><Esc>', '<C-\\><C-n>', {noremap = true})
map('n', '<A-y>',
  ':registers "0123456789abcdefghijklmnopqrstuvwxyz*+.<CR>',
  {noremap = true, silent = true})
map('n', '<space>We', ':e <C-R>=expand("%:p:h") . "/" <CR>',
  {noremap = true})
map('n', '<space>Wt', ':terminal <C-R>=expand("%:p:h") . "/" <CR>',
  {noremap = true})
map('n', '<space>Cfn', ':let @+=expand("%")<CR>', {noremap = true})
map('n', '<space>Cfp', ':let @+=expand("%:p")<CR>', {noremap = true})
map('n', '<space>Cfd', ':let @+=expand("%:p:h")<CR>', {noremap = true})
map('n', '<space>Pp', ":put =execute('')<Left><Left>", {noremap = true})
map('n', '<space>Pv', ":vnew<CR>:put =execute('')<Left><Left>", {noremap = true})
map('n', '<space>Ps', ":new<CR>:put =execute('')<Left><Left>", {noremap = true})
map('n', '<C-l>',
  ':hi Normal ctermbg=NONE guibg=NONE|nohlsearch|diffupdate<CR><C-L>',
  {noremap = true})
local map_opts = {noremap = true, silent = true}
map('i', '<A-p>', '<C-p>', map_opts)
map('i', '<A-n>', '<C-n>', map_opts)
map('i', '<C-p>', '<Up>', map_opts)
map('i', '<C-n>', '<Down>', map_opts)
map('i', '<A-b>', '<S-Left>', map_opts)
map('i', '<A-f>', '<S-Right>', map_opts)
map('i', '<C-b>', '<Left>', map_opts)
map('i', '<C-f>', '<Right>', map_opts)
map('i', '<C-a>', '<Home>', map_opts)
map('i', '<C-e>', '<End>', map_opts)
map('i', '<C-d>', '<Del>', map_opts)
map('i', '<A-d>', '<C-o>dw', map_opts)
map('i', '<A-v>', '<PageUp>', map_opts)
map('i', '<C-v>', '<PageDown>', map_opts)
map('i', '<C-k>', '<C-o>D', map_opts)
-- <C-u> already exists
