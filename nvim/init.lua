local api = vim.api
local opt = vim.opt
local o = vim.o
local wo = vim.wo
local bo = vim.bo
local g = vim.g
local noremap_silent = {noremap = true, silent = true}
local noremap_expr = {noremap = true, expr = true}
local noremap = {noremap = true}
local map = api.nvim_set_keymap
local mapset = vim.keymap.set
local fn = vim.fn
opt.clipboard = ""
api.nvim_command('syntax off')

-- g.did_load_filetypes = 1  -- use {'nathom/filetype.nvim'}

g.mapleader = ' '
g.tokyonight_style = "night"
g.tokyonight_transparent = true
-- g.tokyonight_colors = { fg_gutter = "#ffba00" }
o.shortmess = o.shortmess .. 'A'
o.updatetime = 2000
o.cmdheight = 0
o.showmode = false

-- opt.lazyredraw = true  -- It is only meant to be set temporarily
opt.encoding = 'utf-8'
opt.fileencoding = 'utf-8'
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 2
opt.expandtab = true
opt.list = true
opt.listchars = {tab='⇤·⇥', eol='↲', nbsp='␣', trail='•', extends='⟩', precedes='⟨'}
opt.cursorline = true
-- opt.number = true
-- opt.relativenumber = true
opt.wrap = false
opt.sidescrolloff = 1
opt.foldmethod = "manual"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = true
-- [ nvim-ufo
wo.foldlevel = 99
wo.foldenable = true
-- ]
opt.background = "dark"
opt.signcolumn = "number"
opt.fixendofline = false
-- opt.iskeyword:prepend("-")
-- opt.iskeyword:prepend("$")
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
if vim.fn.executable('fish') == 1 then
  opt.shell = 'fish'
end
g.python3_host_prog = vim.fn.executable('/usr/local/bin/python3') == 1 and
  '/usr/local/bin/python3' or '/usr/bin/python3'
g.netrw_scp_cmd = 'yad --separator= --form --field=Password:H|sshpass scp -q'

-- CSV
g.csv_no_conceal = 1
g.csv_bind_B = 1

-- UNDO
opt.undodir = fn.stdpath('config') .. '/undo'
opt.undofile = true

-- UNDOTREE
g.undotree_WindowLayout = 2

local plugins = o.loadplugins and require('plugins') or {}

vim.cmd([[
  " set clipboard=
  augroup initAutoGroup
    autocmd!
    "  \ *.{c,cpp,h,hbs,htm,html,js,json,jsx,lua,php,py,rs,ts,tsx,md,org} setlocal number
    " autocmd BufRead * if &buftype == '' | setlocal number | endif
    " autocmd BufEnter,FocusGained,InsertLeave * if &buftype == '' | setlocal relativenumber | endif
    " autocmd BufLeave,FocusLost,InsertEnter * if &buftype == '' | setlocal norelativenumber | endif
    autocmd FileType * setlocal formatoptions-=o
    " Org, Neorg
    "autocmd FileType org,norg setlocal tabstop=2 shiftwidth=2
    "  \ foldenable foldmethod=expr foldtext=v:lua.require(\"pretty-fold\").foldtext.global()
    "autocmd FileType lua,html,css,handlebars,json,javascript,javascriptreact,typescript,typescriptreact setlocal tabstop=2 shiftwidth=2
    autocmd FileType sh setlocal iskeyword+=$ iskeyword+={ iskeyword+=}|
      \nnoremap <buffer> * :let @/=substitute(expand('<cword>'),'^\$\?{\?','$\\?{\\?',"").'}\?'<CR>n|
      \nnoremap <buffer> # ?<C-R>=substitute(expand('<cword>'),'^\$\?{\?','$\\={\\=',"")<CR>}\=<CR>
    autocmd FileType php,htmldjango setlocal iskeyword+=$|
      \nnoremap <buffer> * :let @/='\<$\?'.substitute(expand('<cword>'),'^\$','',"").'\>'<CR>n|
      \nnoremap <buffer> # ?\<$\=<C-R>=substitute(expand('<cword>'),'^\$','',"")<CR>\><CR>
    " Recompile plugins.lua
    autocmd BufWritePost plugins.lua source | PackerCompile
    " Terminal config
    autocmd TermOpen * setlocal scrollback=100000 nospell
  augroup end

  highlight Whitespace ctermbg=red guibg=#D2042d

  " SNIPPETS
  " press <Tab> to expand or jump in a snippet. These can also be mapped separately
  " via <Plug>luasnip-expand-snippet and <Plug>luasnip-jump-next.
  imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' 
  " -1 for jumping backwards.
  inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>

  snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<Cr>
  snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<Cr>

  " For changing choices in choiceNodes (not strictly necessary for a basic setup).
  imap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
  smap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'

  " VISUAL MULTI
  let g:VM_set_statusline = 0  " lualine conflict
  let g:VM_silent_exit = 1
  let g:VM_reselect_first = 1
  let g:VM_leader = '\'
  let g:VM_maps = {}
  let g:VM_maps["Add Cursor Down"]    = '<M-j>'
  let g:VM_maps["Add Cursor Up"]      = '<M-k>'

  " Abbreviations
  cabbrev vh vert help
  cabbrev bdn bn<bar>bd#
  cabbrev bdp bp<bar>bd#
  cabbrev Mess Messages
  cabbrev lp lua print
  cabbrev lpi lua print(vim.inspect

  " Commands
  command! SetStatusline lua vim.go.statusline = "%{%v:lua.require'lualine'.statusline()%}"
  command! Q mksession! ~/.config/nvim/session/_last.vim|qall
  command! L source ~/.config/nvim/session/_last.vim
  command! -count=9 Command if bufexists("CommandOutput")|sil! bdelete CommandOutput|endif|
    \bel <count>new|nnoremap <buffer> q :bd<cr>|
    \file CommandOutput|put =execute(\"command\")|setlocal nomod noma buftype=nofile|0goto
  command! -count=9 Autocmd if bufexists("AutocmdOutput")|sil! bdelete AutocmdOutput|endif|
    \bel <count>new|nnoremap <buffer> q :bd<cr>|
    \file AutocmdOutput|put =execute(\"autocmd\")|setlocal nomod noma buftype=nofile|0goto
  command! -count=9 Function if bufexists("FunctionOutput")|sil! bdelete! FunctionOutput|endif|
    \bel <count>new|nnoremap <buffer> q :bd<cr>|
    \file FunctionOutput|put =execute(\"function\")|setlocal nomod noma buftype=nofile|0goto
  command! -count=9 Scriptnames if bufexists("ScriptnamesOutput")|sil! bdelete ScriptnamesOutput|endif|
    \bel <count>new|nnoremap <buffer> q :bd<cr>|
    \file ScriptnamesOutput|put =execute(\"scriptnames\")|setlocal nomod noma buftype=nofile|0goto
  command! -count=9 Map if bufexists("MapOutput")|sil! bdelete MapOutput|endif|bel <count>new|
    \nnoremap <buffer> q :bd<cr>|file MapOutput|put =execute(\"map\")|
    \setlocal nomod noma buftype=nofile|0goto
  command! -count=7 Messages if bufexists("MessagesOutput")|sil! bdelete MessagesOutput|endif|
    \bel <count>new|nnoremap <buffer> q :bd<cr>|
    \file MessagesOutput|put =execute(\"messages\")|setlocal nomod noma buftype=nofile|0goto

  " Functions
  function Getcwdhead()
    return luaeval("vim.fn.getcwd():gsub('.*/', '')")
  endfunction
]])
api.nvim_create_autocmd({ "BufRead" }, {
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
api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter" }, {
  group = "initAutoGroup",
  pattern = {"*"},
  callback = function()
    if o.nu and (bo.buftype == "" or bo.buftype == "acwrite"
        ) and wo.relativenumber ~= true then
      wo.relativenumber = true
    end
  end
})
api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "CmdlineEnter", "WinLeave" }, {
  group = "initAutoGroup",
  pattern = {"*"},
  callback = function()
    if o.nu and (bo.buftype == "" or bo.buftype == "acwrite"
        ) and wo.relativenumber ~= false then
      wo.relativenumber = false
      vim.cmd "redraw"
    end
  end
})
local yank_registers = { "r", "s", "t", "u", "v", "w", "x", "y", "z" }
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
api.nvim_create_autocmd({ "TextYankPost" }, {
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
api.nvim_create_autocmd({ "FocusGained" }, {
  group = "initAutoGroup",
  pattern = {"*"},
  callback = function()
    update_yank_ring('+')
  end
})
-- api.nvim_create_autocmd({"CursorHoldI", "CmdlineEnter"}, {
--   group = "initAutoGroup",
--   pattern = {"*"},
--   callback = function()
--     require'cmp'.complete()
--   end
-- })
api.nvim_create_autocmd({ "CmdlineEnter" }, {
  group = "initAutoGroup",
  pattern = {"*"},
  callback = function()
    o.cmdheight = 1
  end
})
api.nvim_create_autocmd({ "CmdlineLeave" }, {
  group = "initAutoGroup",
  pattern = {"*"},
  callback = function()
    o.cmdheight = 0
  end
})

-- Global functions
function _G.getcwdhead()
  return fn.getcwd():gsub('.*/', '')
end

function _G.set_curr_win(index)
  local wins = api.nvim_tabpage_list_wins(0)
  for k, win in ipairs(wins) do
    if api.nvim_buf_get_name(api.nvim_win_get_buf(win)) == "" then
      table.remove(wins, k)
    end
  end
  local win = wins[index]
  if win then
    api.nvim_set_current_win(win)
  end
end

function _G.int_len(integer)
  integer = math.abs(integer)
  local len = 0
  while integer > 0 do
    len = len + 1
    integer = math.floor(integer / 10)
  end
  return len
end

local filetype_width = {
      ["c"] = 80,
      ["java"] = 110,
      ["javascript"] = 100,
      ["php"] = 80,
      ["python"] = 79,
      ["rs"] = 100,
      ["typescript"] = 100,
}
function _G.win_fit_filetype_width()
  if wo.winfixwidth then
    print("Fixed width window")
    return
  end
  local width = filetype_width[bo.filetype] or 80
  if wo.number then
    width = width + int_len(api.nvim_buf_line_count(0)) + 1
  end
  if opt.listchars:get().eol ~= nil then
    width = width + 1
  end
  api.nvim_win_set_width(0, width)
  wo.winfixwidth = true
  api.nvim_command('horizontal wincmd =')
  wo.winfixwidth = false
end

function _G.win_fit_width_to_content()
  if wo.winfixwidth then
    print("Fixed width window")
    return
  end
  local line_count = api.nvim_buf_line_count(0)
  if line_count > 131072 then
    print("The buffer has too many lines")
    return
  end
  local max_len = 0
  for _, line in ipairs(api.nvim_buf_get_lines(0, 0, -1, true)) do
    local line_len = line:len()
    if line_len > max_len then
      max_len = line_len
    end
  end
  if max_len >= o.winminwidth then
    if wo.number then
      max_len = max_len + int_len(line_count) + 1
    end
    if opt.listchars:get().eol ~= nil then
      max_len = max_len + 1
    end
    api.nvim_win_set_width(0, max_len)
    wo.winfixwidth = true
    api.nvim_command('horizontal wincmd =')
    wo.winfixwidth = false
  end
end

function _G.win_half_width()
  api.nvim_win_set_width(0, math.ceil(api.nvim_win_get_width(0) / 2))
end

function _G.win_double_width()
  api.nvim_win_set_width(0, api.nvim_win_get_width(0) * 2)
end

-- Keymap bindings
map('', '<leader>V', '<cmd>if &virtualedit == "" | setlocal virtualedit=all | else | setlocal virtualedit= | endif<cr>', noremap)
map('t', '<Esc><Esc>', '<C-\\><C-n>', noremap)
map('x', 'zx', "<Esc>:silent 1,'<-1fold<cr>:silent '>+1,$fold<CR>", noremap)
mapset('x', '<leader>p', '"_dP')
mapset({ 'n', 'x' }, '<leader>c', '"_c')
-- added in vim version 0.8.0
-- map('x', '<leader>*', '"0y/<C-R>0<CR>', noremap)
-- map('x', '<leader>#', '"0y?<C-R>0<CR>', noremap)
map('n', 'zdc', ':%g/^[ \t]*class /normal! zc<CR>', noremap)
map('n', 'zdf', ':%g/^[ \t]*\\(function\\|def\\) /normal! zc<CR>', noremap)
map('n', '<leader><Return>', 'i<CR><C-\\><C-n>', noremap)
mapset('n', '<C-W>*', win_double_width)
mapset('n', '<C-W>/', win_half_width)
map('n', '<C-W>0', '<CMD>copen<CR>', noremap)
mapset('n', '<C-W>1', function() set_curr_win(1) end)
mapset('n', '<C-W>2', function() set_curr_win(2) end)
mapset('n', '<C-W>3', function() set_curr_win(3) end)
mapset('n', '<C-W>4', function() set_curr_win(4) end)
mapset('n', '<C-W>5', function() set_curr_win(5) end)
mapset('n', '<C-W>6', function() set_curr_win(6) end)
mapset('n', '<C-W>7', function() set_curr_win(7) end)
mapset('n', '<C-W>8', function() set_curr_win(8) end)
mapset('n', '<C-W>9', function() set_curr_win(9) end)
map('n', '<C-W>s', '<C-W>s:bn<CR>', noremap)
map('n', '<C-W>v', '<C-W>v:bn<CR>', noremap)
mapset('n', '<C-W>w', win_fit_width_to_content)
mapset('n', '<C-W>W', win_fit_filetype_width)
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
map('n', '<leader>Ww', ':w <C-R>=expand("%:p:h") . "/" <CR>', noremap)
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
mapset('n', '<leader>ES', vim.diagnostic.show)
mapset('n', '<leader>Es', function() vim.diagnostic.show(nil, 0) end)
mapset('n', '<leader>EH', vim.diagnostic.hide)
mapset('n', '<leader>Eh', function() vim.diagnostic.hide(nil, 0) end)
-- Emacs style keybindings
map('i', '<A-p>', '<C-p>', noremap_silent)
map('i', '<A-n>', '<C-n>', noremap_silent)
map('i', '<C-p>', '<Up>', noremap_silent)
map('i', '<C-n>', '<Down>', noremap_silent)
map('i', '<A-b>', '<S-Left>', noremap_silent)
map('i', '<A-f>', '<S-Right>', noremap_silent)
map('i', '<C-b>', '<Left>', noremap_silent)
map('i', '<C-f>', '<Right>', noremap_silent)
map('i', '<C-x><C-a>', '<C-a>', noremap_silent)
map('i', '<C-a>', '<Home>', noremap_silent)
map('i', '<C-e>', '<End>', noremap_silent)
map('i', '<C-d>', '<Del>', noremap_silent)
map('i', '<A-d>', '<C-o>dw', noremap_silent)
-- map('i', '<A-v>', '<PageUp>', noremap_silent)
-- map('i', '<C-v>', '<PageDown>', noremap_silent)
map('i', '<C-k>', '<C-o>D', noremap_silent)
-- Both <BS> and <C-BS> sends ^? on terminals
-- map('i', '<C-BS>', '<C-o>db', noremap_silent)
map('i', '<A-BS>', '<C-o>db', noremap_silent)
-- <C-u> already exists
map('c', '<A-p>', '<C-p>', noremap)
map('c', '<A-n>', '<C-n>', noremap)
map('c', '<A-b>', '<C-f>b<C-c>', noremap)
map('c', '<A-f>', '<C-f>e<C-c><Right>', noremap)
map('c', '<C-b>', '<Left>', noremap)
map('c', '<C-f>', 'getcmdpos()>strlen(getcmdline())?&cedit:"\\<Lt>Right>"', noremap_expr)
map('c', '<C-x><C-a>', '<C-a>', noremap)
map('c', '<C-a>', '<Home>', noremap)
-- <C-e> already exists
-- map('c', '<C-e>', '<End>', noremap_silent)
map('c', '<C-d>', 'getcmdpos()>strlen(getcmdline())?"\\<Lt>C-D>":"\\<Lt>Del>"', noremap_expr)
map('c', '<A-d>', '<C-f>dw<C-c>', noremap)
map('c', '<C-k>', '<C-f>D<C-c><Right>', noremap)
map('c', '<A-BS>', '<C-f>db<C-c>', noremap)

vim.defer_fn(function()
  local packer = require'packer'
  for _, plugin in ipairs(plugins) do
    packer.loader(plugin)
  end
  -- local api = vim.api
  -- for _, win in pairs(api.nvim_list_wins()) do
  --   if api.nvim_buf_get_option(api.nvim_win_get_buf(win), 'buftype') == "" then
  --     api.nvim_win_set_option(win, 'spell', true)
  --   end
  -- end
  opt.spell = true
end, 0)
