local api = vim.api
local opt = vim.opt
local wo = vim.wo
local bo = vim.bo
local g = vim.g
local noremap_silent = {noremap = true, silent = true}
local noremap = {noremap = true}
local map = api.nvim_set_keymap
local fn = vim.fn
opt.clipboard = ""
api.nvim_command('syntax off')

-- g.did_load_filetypes = 1  -- use {'nathom/filetype.nvim'}

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
opt.listchars = {tab='⇤ ⇥', eol='↲', nbsp='␣', trail='•', extends='⟩', precedes='⟨'}
opt.cursorline = true
-- opt.number = true
-- opt.relativenumber = true
opt.wrap = false
opt.foldmethod = "manual"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = true
opt.background = "dark"
opt.signcolumn = "number"
opt.fixendofline = false
-- opt.iskeyword:prepend("-")
opt.iskeyword:prepend("$")
-- opt.iskeyword:remove("_")
opt.shada:prepend(":200,'500")
opt.shada:remove("'100")
opt.spelllang = "en_us,es"
opt.spell = false

-- Programs
opt.grepprg = 'rg --vimgrep --smart-case --follow'
opt.clipboard:prepend('unnamedplus')
opt.ignorecase = true
opt.smartcase = true
g.python3_host_prog = vim.fn.executable('/usr/local/bin/python3') == 1 and
  '/usr/local/bin/python3' or '/usr/bin/python3'
g.netrw_scp_cmd = 'yad --separator= --form --field=Password:H|sshpass scp -q'

-- CSV
g.csv_no_conceal = 1
g.csv_bind_B = 1

-- UNDO
opt.undodir = fn.stdpath('config') .. '/undo'
opt.undofile = true

local install_path = fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  fn.execute('!git clone --depth 1 https://github.com/wbthomason/packer.nvim ' .. install_path)
  api.nvim_command 'packadd packer.nvim'
  require('plugins')
  require('packer').install()
else
  local status, result = pcall(require, 'impatient')
  if not status then
    print('loading `impatient`: '..result)
  end
--  result.enable_profile()

  require('plugins')
end

vim.cmd([[
  " set clipboard=
  augroup initAutoGroup
    autocmd!
    "  \ *.{c,cpp,h,hbs,htm,html,js,json,jsx,lua,php,py,rs,ts,tsx,md,org} setlocal number
    " autocmd BufRead * if &buftype == '' | setlocal number | endif
    " autocmd BufEnter,FocusGained,InsertLeave * if &buftype == '' | setlocal relativenumber | endif
    " autocmd BufLeave,FocusLost,InsertEnter * if &buftype == '' | setlocal norelativenumber | endif
    " Org, Neorg
    autocmd FileType org,norg setlocal tabstop=2 shiftwidth=2
      \ foldenable foldmethod=expr foldtext=v:lua.require(\"pretty-fold\").foldtext.global()
    autocmd FileType lua,html,css,handlebars setlocal tabstop=2 shiftwidth=2
    " Recompile plugins.lua
    autocmd BufWritePost plugins.lua source | PackerCompile
    " Terminal config
    autocmd TermOpen * setlocal scrollback=100000 nospell
  augroup end

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

  " Abbreviations
  cabbrev vh vert help
  cabbrev bdn bn<bar>bd#
  cabbrev bdp bp<bar>bd#
  cabbrev Mess Messages

  " Commands
  command! Map bel 7new|file [Map]|put =execute(\"map\")|setlocal nomod noma buftype=nofile|nnoremap <buffer> q :bd<cr>|0goto
  command! Messages bel 7new|file [Messages]|put =execute(\"messages\")|setlocal nomod noma buftype=nofile|nnoremap <buffer> q :bd<cr>|0goto

  " Functions
  function Getcwdhead()
    return luaeval("vim.fn.getcwd():gsub('.*/', '')")
  endfunction
]])
api.nvim_create_autocmd({"BufRead"}, {
  group = "initAutoGroup",
  pattern = {"*"},
  callback = function()
    if bo.buftype == "" or bo.buftype == "acwrite" then
      if wo.number ~= true then
        wo.number = true
      end
    elseif bo.buftype == "help" then
      vim.api.nvim_buf_set_keymap(0, 'n', 'q', '<cmd>bdelete<cr>', noremap)
    end
  end
})
api.nvim_create_autocmd({"BufEnter", "FocusGained", "InsertLeave"}, {
  group = "initAutoGroup",
  pattern = {"*"},
  callback = function()
    if (bo.buftype == "" or bo.buftype == "acwrite"
        ) and wo.relativenumber ~= true then
      wo.relativenumber = true
    end
  end
})
api.nvim_create_autocmd({"BufLeave", "FocusLost", "InsertEnter"}, {
  group = "initAutoGroup",
  pattern = {"*"},
  callback = function()
    if (bo.buftype == "" or bo.buftype == "acwrite"
        ) and wo.relativenumber ~= false then
      wo.relativenumber = false
    end
  end
})
local yank_registers = {"r", "s", "t", "u", "v", "w", "x", "y", "z"}
local update_yank_ring = function(register)
  if fn.getreg(register, 1) == fn.getreg(yank_registers[1], 1) then
    return
  end
  local index = #yank_registers
  for i = 1, index - 1 do
    if fn.getreg(yank_registers[i], 1) == fn.getreg(yank_registers[i + 1], 1) then
      index = i
      break
    end
  end
  for i = index, 2, -1 do
    fn.setreg(yank_registers[i], fn.getreg(yank_registers[i - 1], 1),
              fn.getregtype(yank_registers[i - 1]))
  end
  fn.setreg(yank_registers[1], fn.getreg(register, 1), fn.getregtype(register))
end
api.nvim_create_autocmd({"TextYankPost"}, {
  group = "initAutoGroup",
  pattern = {"*"},
  callback = function()
    local yanked = fn.getreg('"', 1)
    if yanked:len() > 1 and yanked ~= fn.getreg('1', 1) then
      update_yank_ring('"')
      vim.highlight.on_yank { higroup = 'Visual', timeout = 300 }
    end
  end
})
api.nvim_create_autocmd({"FocusGained"}, {
  group = "initAutoGroup",
  pattern = {"*"},
  callback = function()
    update_yank_ring('+')
  end
})

-- Global functions
function _G.getcwdhead()
  return fn.getcwd():gsub('.*/', '')
end

function _G.set_curr_win(index)
  -- local api = vim.api
  local win = api.nvim_list_wins()[index]
  if win then
    api.nvim_set_current_win(win)
  end
end

-- Keymap bindings
map('', '<leader>V', '<cmd>if &virtualedit == "" | setlocal virtualedit=all | else | setlocal virtualedit= | endif<cr>', noremap)
map('t', '<Esc><Esc>', '<C-\\><C-n>', noremap)
map('x', 'zx', "<Esc>:silent 1,'<-1fold<cr>:silent '>+1,$fold<CR>", noremap)
map('x', '<leader>*', '"0y/<C-R>0<CR>', noremap)
map('x', '<leader>#', '"0y?<C-R>0<CR>', noremap)
map('n', '<leader><Return>', 'i<CR><C-\\><C-n>', noremap)
map('n', '<C-W>1', '<CMD>lua set_curr_win(1)<CR>', noremap)
map('n', '<C-W>2', '<CMD>lua set_curr_win(2)<CR>', noremap)
map('n', '<C-W>3', '<CMD>lua set_curr_win(3)<CR>', noremap)
map('n', '<C-W>4', '<CMD>lua set_curr_win(4)<CR>', noremap)
map('n', '<C-W>5', '<CMD>lua set_curr_win(5)<CR>', noremap)
map('n', '<C-W>6', '<CMD>lua set_curr_win(6)<CR>', noremap)
map('n', '<C-W>7', '<CMD>lua set_curr_win(7)<CR>', noremap)
map('n', '<C-W>8', '<CMD>lua set_curr_win(8)<CR>', noremap)
map('n', '<C-W>9', '<CMD>lua set_curr_win(9)<CR>', noremap)
map('n', '<C-W>s', '<C-W>s:bn<CR>', noremap)
map('n', '<C-W>v', '<C-W>v:bn<CR>', noremap)
map('n', '<leader>CC', '<CMD>lclose<CR>', noremap)
map('n', '<leader>Cc', '<CMD>cclose<CR>', noremap)
map('n', '<leader>CO', '<CMD>lopen<CR>', noremap)
map('n', '<leader>Co', '<CMD>copen<CR>', noremap)
map('n', '<leader>CF', '<CMD>lfirst<CR>', noremap)
map('n', '<leader>Cf', '<CMD>cfirst<CR>', noremap)
map('n', '<leader>CN', '<CMD>lnext<CR>', noremap)
map('n', '<leader>Cn', '<CMD>cnext<CR>', noremap)
map('n', '<leader>CP', '<CMD>lprevious<CR>', noremap)
map('n', '<leader>Cp', '<CMD>cprevious<CR>', noremap)
map('n', '<leader>CL', '<CMD>llast<CR>', noremap)
map('n', '<leader>Cl', '<CMD>clast<CR>', noremap)
map('n', '<A-y>',
  ':registers "0123456789abcdefghijklmnopqrstuvwxyz*+.<CR>',
  noremap_silent)
map('n', '<leader>Wc', ':lcd %:h', noremap)
map('n', '<leader>We', ':e <C-R>=expand("%:p:h") . "/" <CR>', noremap)
map('n', '<leader>Ws', ':sp <C-R>=expand("%:p:h") . "/" <CR>', noremap)
map('n', '<leader>Wv', ':vs <C-R>=expand("%:p:h") . "/" <CR>', noremap)
map('n', '<leader>Wt', ':terminal <C-R>=expand("%:p:h") . "/" <CR>',
  noremap)
map('n', '<leader>Yfn', ':let @+=expand("%")<CR>', noremap)
map('n', '<leader>Yfp', ':let @+=expand("%:p")<CR>', noremap)
map('n', '<leader>Yfd', ':let @+=expand("%:p:h")<CR>', noremap)
map('n', '<leader>Pp', ':put =execute(\\"\\")<Left><Left><Left>', noremap)
map('n', '<leader>Pv', ':vnew<CR>:put =execute(\\"\\")<Left><Left><Left>', noremap)
map('n', '<leader>Ps', ':new<CR>:put =execute(\\"\\")<Left><Left><Left>', noremap)
map('n', '<C-l>',
  ':hi Normal ctermbg=NONE guibg=NONE|nohlsearch|diffupdate<CR><C-L>',
  noremap)
map('n', '<leader>S:',
  ':mkview! ~/.config/nvim/session/_view.vim<CR>:bn|bd#',
  noremap)
map('n', '<leader>S.',
  ':source ~/.config/nvim/session/_view.vim<CR>',
  noremap)
map('n', '<leader>S_',
  ':mksession! ~/.config/nvim/session/_last.vim<CR>',
  noremap)
map('n', '<leader>S-',
  ':source ~/.config/nvim/session/_last.vim<CR>',
  noremap)
map('n', '<leader>SS',
  ':mksession! ~/.config/nvim/session/.vim<Left><Left><Left><Left>',
  noremap)
map('n', '<leader>Ss',
  ':mksession ~/.config/nvim/session/.vim<Left><Left><Left><Left>',
  noremap)
map('n', '<leader>SV',
  ':mkview! ~/.config/nvim/session/.vim<Left><Left><Left><Left>',
  noremap)
map('n', '<leader>Sv',
  ':mkview ~/.config/nvim/session/.vim<Left><Left><Left><Left>',
  noremap)
map('n', '<leader>Sl',
  ':source ~/.config/nvim/session/',
  noremap)
map('n', '<leader>SWS',
  ':mksession! ~/.config/nvim/session/<C-R>=v:lua.getcwdhead()<CR>-.vim<Left><Left><Left><Left>',
  noremap)
map('n', '<leader>SWs',
  ':mksession ~/.config/nvim/session/<C-R>=v:lua.getcwdhead()<CR>-.vim<Left><Left><Left><Left>',
  noremap)
map('n', '<leader>SWV',
  ':mkview! ~/.config/nvim/session/<C-R>=v:lua.getcwdhead()<CR>-.vim<Left><Left><Left><Left>',
  noremap)
map('n', '<leader>SWv',
  ':mkview ~/.config/nvim/session/<C-R>=v:lua.getcwdhead()<CR>-.vim<Left><Left><Left><Left>',
  noremap)
map('n', '<leader>SWl',
  ':source ~/.config/nvim/session/<C-R>=v:lua.getcwdhead()<CR>',
  noremap)
-- Emacs style keybindings
map('i', '<A-p>', '<C-p>', noremap_silent)
map('i', '<A-n>', '<C-n>', noremap_silent)
map('i', '<C-p>', '<Up>', noremap_silent)
map('i', '<C-n>', '<Down>', noremap_silent)
map('i', '<A-b>', '<S-Left>', noremap_silent)
map('i', '<A-f>', '<S-Right>', noremap_silent)
map('i', '<C-b>', '<Left>', noremap_silent)
map('i', '<C-f>', '<Right>', noremap_silent)
map('i', '<C-a>', '<Home>', noremap_silent)
map('i', '<C-e>', '<End>', noremap_silent)
map('i', '<C-d>', '<Del>', noremap_silent)
map('i', '<A-d>', '<C-o>dw', noremap_silent)
-- map('i', '<A-v>', '<PageUp>', noremap_silent)
-- map('i', '<C-v>', '<PageDown>', noremap_silent)
map('i', '<C-k>', '<C-o>D', noremap_silent)
-- <C-u> already exists

vim.defer_fn(function()
  local packer = require'packer'
  packer.loader('tokyonight.nvim')
  packer.loader('nvim-treesitter')
  packer.loader('undotree')
  packer.loader('which-key.nvim')
  packer.loader('nvim-cmp')
  packer.loader('pretty-fold.nvim')
  packer.loader('gitsigns.nvim')
  packer.loader('vim-repeat')
  packer.loader('vim-surround')
  -- local api = vim.api
  -- for _, win in pairs(api.nvim_list_wins()) do
  --   if api.nvim_buf_get_option(api.nvim_win_get_buf(win), 'buftype') == "" then
  --     api.nvim_win_set_option(win, 'spell', true)
  --   end
  -- end
  opt.spell = true
end, 0)
