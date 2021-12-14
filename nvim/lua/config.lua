local opt = vim.opt
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
opt.foldmethod="expr"
opt.foldexpr="nvim_treesitter#foldexpr()"
opt.foldenable = false
opt.background = "dark"

-- Programs
opt.grepprg = 'rg --vimgrep --smart-case --follow'
opt.clipboard:prepend('unnamedplus')
opt.ignorecase = true
opt.smartcase = true

-- UNDO
opt.undodir = vim.fn.stdpath('config') .. '/undo'
opt.undofile = true

vim.g.mapleader = ' '
vim.g.tokyonight_style = "night"
vim.g.tokyonight_transparent = true
-- vim.g.tokyonight_colors = { fg_gutter = "#ffba00" }

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

require('plugins')
require('packer_compiled')

vim.cmd [[
  " packadd packer.nvim

  augroup init_colorscheme
    autocmd!
    autocmd ColorScheme *
      \ highlight LineNr guifg=#5081c0 | highlight CursorLineNR guifg=#ffba00
  "     \   hi Normal     ctermbg=NONE guibg=NONE
  "     \ | hi LineNr     ctermfg=grey guifg=grey
  "     \ | hi Pmenu      ctermbg=DarkGrey guibg=DarkGrey
  "     \ | hi MatchParen cterm=bold gui=bold ctermfg=magenta guifg=magenta ctermbg=black guibg=black
  augroup END
  colorscheme tokyonight

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

  " add
  silent! map <unique> <C-s>a <Plug>(sandwich-add)

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
]]

-- Emacs keys
-- local map_opts = {noremap = true, silent = true}
-- map('i', '<A-p>', '<C-p>', map_opts)
-- map('i', '<A-n>', '<C-n>', map_opts)
-- map('i', '<C-p>', '<Up>', map_opts)
-- map('i', '<C-n>', '<Down>', map_opts)
-- map('i', '<A-b>', '<S-Left>', map_opts)
-- map('i', '<A-f>', '<S-Right>', map_opts)
-- map('i', '<C-b>', '<Left>', map_opts)
-- map('i', '<C-f>', '<Right>', map_opts)
-- map('i', '<C-a>', '<Home>', map_opts)
-- map('i', '<C-e>', '<End>', map_opts)
-- map('i', '<C-d>', '<Del>', map_opts)
-- map('i', '<A-v>', '<PageUp>', map_opts)
-- map('i', '<C-v>', '<PageDown>', map_opts)
-- map('i', '<C-k>', '<Esc>lDa', map_opts)
-- map('i', '<C-u>', '<Esc>d0xi', map_opts)
-- 
-- map('c', '<C-p>', '<Up>', map_opts)
-- map('c', '<C-n>', '<Down>', map_opts)
-- map('c', '<C-b>', '<Left>', map_opts)
-- map('c', '<C-f>', '<Right>', map_opts)
-- map('c', '<A-b>', '<S-Left>', map_opts)
-- map('c', '<A-f>', '<S-Right>', map_opts)
-- map('c', '<C-a>', '<Home>', map_opts)
-- map('c', '<C-e>', '<End>', map_opts)
-- map('c', '<C-d>', '<C-h>', map_opts)
