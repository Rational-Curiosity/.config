local api = vim.api
local opt = vim.opt
local o = vim.o
local bo = vim.bo
local g = vim.g
local noremap_silent = {noremap = true, silent = true}
local noremap_expr = {noremap = true, expr = true}
local noremap = {noremap = true}
-- local map = api.nvim_set_keymap
local mapset = vim.keymap.set
local fn = vim.fn
opt.clipboard = ""

-- g.did_load_filetypes = 1  -- use {'nathom/filetype.nvim'}

g.tokyonight_style = "night"
g.tokyonight_transparent = true
-- g.tokyonight_colors = { fg_gutter = "#ffba00" }
o.shortmess = o.shortmess .. 'A'
o.updatetime = 2000
o.cmdheight = 0
o.showmode = false
o.fileencoding = 'utf-8'
-- [ nvim-ufo
o.foldlevel = 99
o.foldenable = true
-- ]

-- opt.lazyredraw = true  -- It is only meant to be set temporarily
opt.encoding = 'utf-8'
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 2
opt.expandtab = true
opt.list = true
opt.listchars = {
  tab='⇤·⇥', eol='↲', nbsp='␣', trail='•', extends='⟩', precedes='⟨',
}
opt.cursorline = true
-- opt.number = true
-- opt.relativenumber = true
opt.wrap = false
opt.sidescrolloff = 1
opt.foldmethod = "manual"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = true
opt.background = "dark"
opt.numberwidth = 2
opt.signcolumn = "auto:1" -- "number"
opt.fixendofline = false
-- opt.iskeyword:prepend("-")
-- opt.iskeyword:prepend("$")
-- opt.iskeyword:remove("_")
opt.shada:prepend(":200,'500")
opt.shada:remove("'100")
opt.spelllang = "en_us,es"

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
g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0

-- CSV
g.csv_no_conceal = 1
g.csv_bind_B = 1

-- UNDO
opt.undodir = fn.stdpath('config') .. '/undo'
opt.undofile = true

-- UNDOTREE
g.undotree_WindowLayout = 2

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
    "autocmd BufWritePost plugins.lua source | PackerCompile
    " Terminal config
    autocmd TermOpen term://* setlocal scrollback=100000 nospell|startinsert
    autocmd BufWinEnter,WinEnter term://* startinsert
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
  cabbrev <expr> E getcmdpos() == 2 && getcmdtype() == ':' ? 'e '.expand('%:p:h') : 'E'
  cabbrev <expr> VS getcmdpos() == 3 && getcmdtype() == ':' ? 'vs '.expand('%:p:h') : 'VS'
  cabbrev <expr> SP getcmdpos() == 3 && getcmdtype() == ':' ? 'sp '.expand('%:p:h') : 'SP'
  cabbrev <expr> vh getcmdpos() == 3 && getcmdtype() == ':' ? 'vert help' : 'vh'
  cabbrev <expr> bdn getcmdtype() == ':' ? 'bn<bar>bd#' : 'bdn'
  cabbrev <expr> bdp getcmdtype() == ':' ? 'bp<bar>bd#' : 'bdp'
  cabbrev <expr> Mess getcmdpos() == 5 && getcmdtype() == ':' ? 'Messages' : 'Mess'
  cabbrev <expr> lp getcmdpos() == 3 && getcmdtype() == ':' ? 'lua print' : 'lp'
  cabbrev <expr> lpi getcmdpos() == 4 && getcmdtype() == ':' ? 'lua print(vim.inspect' : 'lpi'

  " Commands
  " command! -nargs=1 E exec 'e' expand('%:p:h').'/'.<f-args>
  command! Cd exec 'cd' fnameescape(finddir('.git/..', escape(expand('%:p:h'), ' ').';'))
  command! Lcd exec 'lcd' fnameescape(finddir('.git/..', escape(expand('%:p:h'), ' ').';'))
  command! SetStatusline lua vim.go.statusline = "%{%v:lua.require'lualine'.statusline()%}"
  command! Q mksession! ~/.config/nvim/session/_last.vim|qall
  command! S mksession! ~/.config/nvim/session/_last.vim
  command! L source ~/.config/nvim/session/_last.vim
  command! Vterm 72vs|exe "term"|setlocal wfw|exe "normal \<c-w>r\<c-w>="
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
  command! -count=9 Hi if bufexists("HiOutput")|sil! bdelete HiOutput|endif|bel <count>new|
    \nnoremap <buffer> q :bd<cr>|file HiOutput|put =execute(\"hi\")|
    \setlocal nomod noma buftype=nofile|0goto
  command! -count=7 Messages if bufexists("MessagesOutput")|sil! bdelete MessagesOutput|endif|
    \bel <count>new|nnoremap <buffer> q :bd<cr>|
    \file MessagesOutput|put =execute(\"messages\")|setlocal nomod noma buftype=nofile|0goto

  " Functions
  function Getcwdhead()
    return luaeval("vim.fn.getcwd():gsub('.*/', '')")
  endfunction
]])
local wo = vim.wo
api.nvim_create_autocmd({ "TermEnter" }, {
  group = "initAutoGroup",
  pattern = {"*"},
  callback = function()
    wo.relativenumber = false
    wo.number = false
  end
})
api.nvim_create_autocmd({ "TermLeave" }, {
  group = "initAutoGroup",
  pattern = {"*"},
  callback = function()
    wo.number = true
    wo.relativenumber = true
  end
})
api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
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
api.nvim_create_autocmd({
  "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter",
}, {
  group = "initAutoGroup",
  pattern = {"*"},
  callback = function()
    if o.nu and (bo.buftype == "" or bo.buftype == "acwrite"
        ) and wo.relativenumber ~= true then
      wo.relativenumber = true
    end
  end
})
api.nvim_create_autocmd({
  "BufLeave", "FocusLost", "InsertEnter", "CmdlineEnter", "WinLeave",
}, {
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
do
  local yank_registers = { "r", "s", "t", "u", "v", "w", "x", "y", "z" }
  local update_yank_ring = function(register)
    if fn.getreg(register, 1) == fn.getreg(yank_registers[1], 1) then
      return
    end
    local index = #yank_registers
    for i = 1, index - 1 do
      if fn.getreg(yank_registers[i], 1)
        == fn.getreg(yank_registers[i + 1], 1) then
        index = i
        break
      end
    end
    for i = index, 2, -1 do
      fn.setreg(yank_registers[i], fn.getreg(yank_registers[i - 1], 1),
                fn.getregtype(yank_registers[i - 1]))
    end
    fn.setreg(
      yank_registers[1], fn.getreg(register, 1), fn.getregtype(register)
    )
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
end
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
do
  local filetype_max_line_length = {
        c = 80,
        java = 110,
        javascript = 100,
        lua = 80,
        php = 80,
        python = 79,
        rs = 100,
        typescript = 100,
  }
  api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
    group = "initAutoGroup",
    pattern = {"*"},
    callback = function()
      local columns = filetype_max_line_length[bo.filetype]
      if columns then
        local last_pos = fn.getpos("']")
        if last_pos[4] ~= 0 then
          return
        end
        local last = last_pos[2]
        local first = fn.getpos("'[")[2]
        if wo.colorcolumn == '' then
          local lines = api.nvim_buf_get_lines(0, first - 1, last, false)
          if next(lines) == nil then
            return
          end
          local max_index = #lines
          local max_len = fn.strdisplaywidth(table.remove(lines))
          for index, line in pairs(lines) do
            local line_len = fn.strdisplaywidth(line)
            if line_len > max_len then
              max_len = line_len
              max_index = index
            end
          end
          if columns < max_len then
            api.nvim_buf_set_mark(
              0, "r", first + max_index - 1, max_len - 1, {}
            )
            vim.opt_local.colorcolumn = tostring(columns + 1)
          end
        else
          local max_mark = api.nvim_buf_get_mark(0, "r")[1]
          if max_mark ~= 0 then
            if max_mark + 1 < first or last < max_mark then
              return
            end
            local lines = api.nvim_buf_get_lines(
              0, max_mark - 1, max_mark + 1, false
            )
            if next(lines) ~= nil then
              local max_len = fn.strdisplaywidth(table.remove(lines))
              for _, line in pairs(lines) do
                local line_len = fn.strdisplaywidth(line)
                if line_len > max_len then
                  max_len = line_len
                end
              end
              if columns < max_len then
                return
              end
            end
          end
          api.nvim_buf_del_mark(0, "r")
          local first = vim.fn.line("w0")
          lines = api.nvim_buf_get_lines(
            0, first - 1, vim.fn.line("w$"), true
          )
          local max_index = #lines
          local max_len = fn.strdisplaywidth(table.remove(lines))
          for index, line in pairs(lines) do
            local line_len = fn.strdisplaywidth(line)
            if line_len > max_len then
              max_len = line_len
              max_index = index
            end
          end
          if columns < max_len then
            api.nvim_buf_set_mark(
              0, "r", first + max_index - 1, max_len - 1, {}
            )
          else
            vim.opt_local.colorcolumn = ''
          end
        end
      end
    end
  })
  function _G.win_fit_filetype_width()
    if wo.winfixwidth then
      print("Fixed width window")
      return
    end
    local width = filetype_max_line_length[bo.filetype] or 80
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
end

-- Notifications
do
  local orig_notify_once = vim.notify_once
  vim.notify_once = function(msg, level, opts)
    if msg:sub(1, 47) == 'vim.treesitter.get_node_at_pos() is deprecated,' then
      return
    end
    orig_notify_once(msg, level, opts)
  end
end

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
  local lines = api.nvim_buf_get_lines(0, 0, -1, true)
  local max_len = fn.strdisplaywidth(table.remove(lines))
  for _, line in pairs(lines) do
    local line_len = fn.strdisplaywidth(line)
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
mapset('', '<leader>V',
  '<cmd>if &virtualedit == "" | setlocal virtualedit=all | else | setlocal virtualedit= | endif<cr>',
  noremap)
mapset('t', '<Esc><Esc>', '<C-\\><C-n>', noremap)
mapset('x', 'zx', "<Esc>:silent 1,'<-1fold<cr>:silent '>+1,$fold<CR>", noremap)
mapset('x', '\\p', '"_dP')
mapset({ 'n', 'x' }, '\\c', '"_c')
mapset({ 'n', 'x' }, '\\d', '"_d')
-- added in vim version 0.8.0
-- map('x', '<leader>*', '"0y/<C-R>0<CR>', noremap)
-- map('x', '<leader>#', '"0y?<C-R>0<CR>', noremap)
mapset('n', 'zdc', ':%g/^[ \t]*class /normal! zc<CR>', noremap)
mapset('n', 'zdf', ':%g/^[ \t]*\\(function\\|def\\) /normal! zc<CR>', noremap)
mapset('n', '<leader><Return>', 'i<CR><C-\\><C-n>', noremap)
mapset('n', '<C-W>*', win_double_width)
mapset('n', '<C-W>/', win_half_width)
mapset('n', '<C-W>0', '<CMD>copen<CR>', noremap)
mapset('n', '<C-W>1', function() set_curr_win(1) end)
mapset('n', '<C-W>2', function() set_curr_win(2) end)
mapset('n', '<C-W>3', function() set_curr_win(3) end)
mapset('n', '<C-W>4', function() set_curr_win(4) end)
mapset('n', '<C-W>5', function() set_curr_win(5) end)
mapset('n', '<C-W>6', function() set_curr_win(6) end)
mapset('n', '<C-W>7', function() set_curr_win(7) end)
mapset('n', '<C-W>8', function() set_curr_win(8) end)
mapset('n', '<C-W>9', function() set_curr_win(9) end)
mapset('n', '<C-W>w', win_fit_width_to_content)
mapset('n', '<C-W>W', win_fit_filetype_width)
mapset('n', '<leader>CC', '<CMD>lclose<CR>', noremap)
mapset('n', '<leader>Cc', '<CMD>cclose<CR>', noremap)
mapset('n', '<leader>CO', '<CMD>lopen<CR>', noremap)
mapset('n', '<leader>Co', '<CMD>copen<CR>', noremap)
mapset('n', '<leader>CF', '<CMD>lfirst<CR>', noremap)
mapset('n', '<leader>Cf', '<CMD>cfirst<CR>', noremap)
mapset('n', '<leader>CN', '<CMD>lnext<CR>', noremap)
mapset('n', '<leader>Cn', '<CMD>cnext<CR>', noremap)
mapset('n', '<leader>CP', '<CMD>lprevious<CR>', noremap)
mapset('n', '<leader>Cp', '<CMD>cprevious<CR>', noremap)
mapset('n', '<leader>CL', '<CMD>llast<CR>', noremap)
mapset('n', '<leader>Cl', '<CMD>clast<CR>', noremap)
mapset('n', '<A-y>',
  ':registers "0123456789abcdefghijklmnopqrstuvwxyz*+.<CR>',
  noremap_silent)
mapset('n', '<leader>Wc', ':lcd %:h', noremap)
mapset('n', '<leader>We', ':e <C-R>=expand("%:p:h") . "/" <CR>', noremap)
mapset('n', '<leader>Ww', ':w <C-R>=expand("%:p:h") . "/" <CR>', noremap)
mapset('n', '<leader>Ws', ':sp <C-R>=expand("%:p:h") . "/" <CR>', noremap)
mapset('n', '<leader>Wv', ':vs <C-R>=expand("%:p:h") . "/" <CR>', noremap)
mapset('n', '<leader>Wt', ':terminal <C-R>=expand("%:p:h") . "/" <CR>',
  noremap)
mapset('n', '<leader>Yfn', ':let @+=expand("%")<CR>', noremap)
mapset('n', '<leader>Yfp', ':let @+=expand("%:p")<CR>', noremap)
mapset('n', '<leader>Yfd', ':let @+=expand("%:p:h")<CR>', noremap)
mapset('n', '<leader>Pp', ':put =execute(\\"\\")<Left><Left><Left>', noremap)
mapset(
  'n', '<leader>Pv', ':vnew<CR>:put =execute(\\"\\")<Left><Left><Left>', noremap
)
mapset(
  'n', '<leader>Ps', ':new<CR>:put =execute(\\"\\")<Left><Left><Left>', noremap
)
mapset('n', '<C-l>',
  ':hi Normal ctermbg=NONE guibg=NONE|nohlsearch|diffupdate<CR><C-L>',
  noremap)
mapset('n', '<leader>S:',
  ':mkview! ~/.config/nvim/session/_view.vim<CR>:bn|bd#',
  noremap)
mapset('n', '<leader>S.',
  ':source ~/.config/nvim/session/_view.vim<CR>',
  noremap)
mapset('n', '<leader>S_',
  ':mksession! ~/.config/nvim/session/_last.vim<CR>',
  noremap)
mapset('n', '<leader>S-',
  ':source ~/.config/nvim/session/_last.vim<CR>',
  noremap)
mapset('n', '<leader>SS',
  ':mksession! ~/.config/nvim/session/.vim<Left><Left><Left><Left>',
  noremap)
mapset('n', '<leader>Ss',
  ':mksession ~/.config/nvim/session/.vim<Left><Left><Left><Left>',
  noremap)
mapset('n', '<leader>SV',
  ':mkview! ~/.config/nvim/session/.vim<Left><Left><Left><Left>',
  noremap)
mapset('n', '<leader>Sv',
  ':mkview ~/.config/nvim/session/.vim<Left><Left><Left><Left>',
  noremap)
mapset('n', '<leader>Sl',
  ':source ~/.config/nvim/session/',
  noremap)
mapset('n', '<leader>SWS',
  ':mksession! ~/.config/nvim/session/<C-R>=v:lua.getcwdhead()<CR>-.vim<Left><Left><Left><Left>',
  noremap)
mapset('n', '<leader>SWs',
  ':mksession ~/.config/nvim/session/<C-R>=v:lua.getcwdhead()<CR>-.vim<Left><Left><Left><Left>',
  noremap)
mapset('n', '<leader>SWV',
  ':mkview! ~/.config/nvim/session/<C-R>=v:lua.getcwdhead()<CR>-.vim<Left><Left><Left><Left>',
  noremap)
mapset('n', '<leader>SWv',
  ':mkview ~/.config/nvim/session/<C-R>=v:lua.getcwdhead()<CR>-.vim<Left><Left><Left><Left>',
  noremap)
mapset('n', '<leader>SWl',
  ':source ~/.config/nvim/session/<C-R>=v:lua.getcwdhead()<CR>',
  noremap)
mapset('n', '<leader>ES', vim.diagnostic.show)
mapset('n', '<leader>Es', function() vim.diagnostic.show(nil, 0) end)
mapset('n', '<leader>EH', vim.diagnostic.hide)
mapset('n', '<leader>Eh', function() vim.diagnostic.hide(nil, 0) end)
-- Emacs style keybindings
mapset('i', '<A-p>', '<C-p>', noremap_silent)
mapset('i', '<A-n>', '<C-n>', noremap_silent)
mapset('i', '<C-p>', '<Up>', noremap_silent)
mapset('i', '<C-n>', '<Down>', noremap_silent)
mapset('i', '<A-b>', '<S-Left>', noremap_silent)
mapset('i', '<A-f>', '<S-Right>', noremap_silent)
mapset('i', '<C-b>', '<Left>', noremap_silent)
mapset('i', '<C-f>', '<Right>', noremap_silent)
mapset('i', '<C-x><C-a>', '<C-a>', noremap_silent)
mapset('i', '<C-a>', '<Home>', noremap_silent)
mapset('i', '<C-e>', '<End>', noremap_silent)
mapset('i', '<C-d>', '<Del>', noremap_silent)
mapset('i', '<A-d>', '<C-o>dw', noremap_silent)
-- mapset('i', '<A-v>', '<PageUp>', noremap_silent)
-- mapset('i', '<C-v>', '<PageDown>', noremap_silent)
mapset('i', '<C-k>', '<C-o>D', noremap_silent)
-- Both <BS> and <C-BS> sends ^? on terminals
-- mapset('i', '<C-BS>', '<C-o>db', noremap_silent)
mapset('i', '<A-BS>', '<Left><C-o>dvb', noremap_silent)
-- <C-u> already exists
mapset('c', '<A-p>', '<C-p>', noremap)
mapset('c', '<A-n>', '<C-n>', noremap)
mapset('c', '<A-b>', '<C-f>b<C-c>', noremap)
mapset('c', '<A-f>', '<C-f>e<C-c><Right>', noremap)
mapset('c', '<C-b>', '<Left>', noremap)
mapset('c', '<C-f>', function()
  -- 'getcmdpos()>strlen(getcmdline())?&cedit:"\\<Lt>Right>"'
  if vim.fn.getcmdpos() > vim.fn.getcmdline():len() then
    return '<C-f>'
  else
    return '<Right>'
  end
end, noremap_expr)
mapset('c', '<C-x><C-a>', '<C-a>', noremap)
mapset('c', '<C-a>', '<Home>', noremap)
-- <C-e> already exists
-- mapset('c', '<C-e>', '<End>', noremap_silent)
mapset('c', '<C-d>', function()
  -- 'getcmdpos()>strlen(getcmdline())?"\\<Lt>C-D>":"\\<Lt>Del>"'
  if vim.fn.getcmdpos() > vim.fn.getcmdline():len() then
    return '<C-d>'
  else
    return '<Del>'
  end
end, noremap_expr)
mapset('c', '<A-d>', '<C-f>dw<C-c>', noremap)
mapset('c', '<C-k>', '<C-f>D<C-c><Right>', noremap)
mapset('c', '<A-BS>', function()
  if vim.fn.getcmdpos() > vim.fn.getcmdline():len() then
    return '<C-f>dvb<C-c><Right>'
  else
    return '<C-f>db<C-c>'
  end
end, noremap_expr)
