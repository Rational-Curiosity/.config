-- vim.lsp.set_log_level('debug')
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

-- g.did_load_filetypes = 1  -- use {'nathom/filetype.nvim'}

g.editorconfig = false
g.tokyonight_style = "night"
g.tokyonight_transparent = true
-- g.tokyonight_colors = { fg_gutter = "#ffba00" }
o.shortmess = o.shortmess .. 'A'
o.updatetime = 2000
o.cmdheight = 0
o.showmode = false
o.fileencoding = 'utf-8'
o.redrawtime = 150
o.synmaxcol = 400

-- opt.lazyredraw = true  -- It is only meant to be set temporarily
o.encoding = 'utf-8'
o.tabstop = 4
o.shiftwidth = 4
o.softtabstop = 2
o.expandtab = true
o.list = true
opt.listchars = {
  tab='⇤·⇥', eol='↲', nbsp='␣', trail='•', extends='⟩', precedes='⟨',
}
o.cursorline = true
o.wrap = false
o.sidescrolloff = 1
o.foldmethod = "manual"
o.foldexpr = "nvim_treesitter#foldexpr()"
o.foldenable = true
o.foldlevel = 99
o.foldlevelstart = 99
o.background = "dark"
o.numberwidth = 3
o.signcolumn = "number"
o.fixendofline = false
-- opt.iskeyword:prepend("-")
-- opt.iskeyword:prepend("$")
-- opt.iskeyword:remove("_")
opt.shada:prepend(":200,'500")
opt.shada:remove("'100")
o.spelllang = "en_us,es"

-- Programs
o.grepprg = 'rg --vimgrep --smart-case --follow'
opt.clipboard:prepend('unnamedplus')
o.ignorecase = true
o.smartcase = true
o.shell = 'sh'
g.python3_host_prog = vim.fn.executable('/usr/local/bin/python3') == 1
  and '/usr/local/bin/python3' or '/usr/bin/python3'
g.netrw_scp_cmd = 'yad --separator= --form --field=Password:H|sshpass scp -q'
g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0

-- UNDO
o.undodir = fn.stdpath('config') .. '/undo'
o.undofile = true

-- UNDOTREE
g.undotree_WindowLayout = 2

vim.cmd([[
  syn sync maxlines=200
  syn sync minlines=80
  augroup initAutoGroup
    autocmd!
    "  \ *.{c,cpp,h,hbs,htm,html,js,json,jsx,lua,php,py,rs,ts,tsx,md,org} setlocal number
    " autocmd BufRead * if &buftype == '' | setlocal number | endif
    " autocmd BufEnter,FocusGained,InsertLeave * if &buftype == '' | setlocal relativenumber | endif
    " autocmd BufLeave,FocusLost,InsertEnter * if &buftype == '' | setlocal norelativenumber | endif
    " Org, Neorg
    "autocmd FileType org,norg setlocal tabstop=2 shiftwidth=2
    "  \ foldenable foldmethod=expr foldtext=v:lua.require(\"pretty-fold\").foldtext.global()
    "autocmd FileType lua,html,css,handlebars,json,javascript,javascriptreact,typescript,typescriptreact setlocal tabstop=2 shiftwidth=2
    " autocmd FileType sh setlocal iskeyword+=$ iskeyword+={ iskeyword+=}|
    "   \nnoremap <buffer> * :let @/=substitute(expand('<cword>'),'^\$\?{\?','$\\?{\\?',"").'}\?'<CR>n|
    "   \nnoremap <buffer> # ?<C-R>=substitute(expand('<cword>'),'^\$\?{\?','$\\={\\=',"")<CR>}\=<CR>
    " autocmd FileType php,htmldjango setlocal iskeyword+=$|
    "   \nnoremap <buffer> * :let @/='\<$\?'.substitute(expand('<cword>'),'^\$','',"").'\>'<CR>n|
    "   \nnoremap <buffer> # ?\<$\=<C-R>=substitute(expand('<cword>'),'^\$','',"")<CR>\><CR>
    " autocmd FileType log setlocal nospell
    " Recompile plugins.lua
    "autocmd BufWritePost plugins.lua source | PackerCompile
    " Terminal config
    autocmd TermOpen term://* setlocal scrollback=100000 nospell|startinsert
    autocmd BufWinEnter,WinEnter term://* startinsert
  augroup end

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

  " MATCHPAREN
  let g:matchparen_timeout = 150
  let g:matchparen_insert_timeout = 50

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
  cabbrev <expr> dn getcmdpos() == 3 && getcmdtype() == ':' ? 'DiagNext' : 'dn'
  cabbrev <expr> dp getcmdpos() == 3 && getcmdtype() == ':' ? 'DiagPrev' : 'dp'
  cabbrev <expr> term getcmdpos() == 5 && getcmdtype() == ':' ? 'Term' : 'term'

  " Commands
  command! Cd exec 'cd' fnameescape(finddir('.git/..', escape(expand('%:p:h'), ' ').';'))
  command! Lcd exec 'lcd' fnameescape(finddir('.git/..', escape(expand('%:p:h'), ' ').';'))
  command! SetStatusline lua vim.go.statusline = "%{%v:lua.require'lualine'.statusline()%}"
  command! DiagNext lua vim.diagnostic.goto_next()
  command! DiagPrev lua vim.diagnostic.goto_prev()
  command! -complete=custom,LastSavedSession -nargs=? Q mksession! ~/.config/nvim/session/_last_<args>.vim|qall
  command! -complete=custom,LastSavedSession -nargs=? S mksession! ~/.config/nvim/session/_last_<args>.vim
  command! -complete=custom,LastSavedSession -nargs=? L source ~/.config/nvim/session/_last_<args>.vim
  command! -nargs=* Term set shell=fish|exe "term ".<q-args>|set shell=sh
  command! -count=72 -nargs=* VTerm vert botright <count>split|exe "Term ".<q-args>|setlocal wfw|exe "normal \<c-w>="
  command! -count=10 -nargs=* HTerm botright <count>split|exe "Term ".<q-args>|setlocal wfh|exe "normal \<c-w>="
  command! -count=9 Command if bufexists("CommandOutput")|sil! bdelete CommandOutput|endif|
    \bel <count>new|nnoremap <silent> <buffer> q :bd<cr>|
    \file CommandOutput|put =execute(\"command\")|setlocal nomod noma buftype=nofile|0goto
  command! -count=9 Autocmd if bufexists("AutocmdOutput")|sil! bdelete AutocmdOutput|endif|
    \bel <count>new|nnoremap <silent> <buffer> q :bd<cr>|
    \file AutocmdOutput|put =execute(\"autocmd\")|setlocal nomod noma buftype=nofile|0goto
  command! -count=9 Function if bufexists("FunctionOutput")|sil! bdelete! FunctionOutput|endif|
    \bel <count>new|nnoremap <silent> <buffer> q :bd<cr>|
    \file FunctionOutput|put =execute(\"function\")|setlocal nomod noma buftype=nofile|0goto
  command! -count=9 Scriptnames if bufexists("ScriptnamesOutput")|sil! bdelete ScriptnamesOutput|endif|
    \bel <count>new|nnoremap <silent> <buffer> q :bd<cr>|
    \file ScriptnamesOutput|put =execute(\"scriptnames\")|setlocal nomod noma buftype=nofile|0goto
  command! -count=9 Map if bufexists("MapOutput")|sil! bdelete MapOutput|endif|
    \bel <count>new|nnoremap <silent> <buffer> q :bd<cr>|file MapOutput|put =execute(\"map\")|
    \setlocal nomod noma buftype=nofile|0goto
  command! -count=9 Hi if bufexists("HiOutput")|sil! bdelete HiOutput|endif|
    \bel <count>new|nnoremap <silent> <buffer> q :bd<cr>|file HiOutput|put =execute(\"hi\")|
    \setlocal nomod noma buftype=nofile|0goto
  command! -count=7 Messages if bufexists("MessagesOutput")|sil! bdelete MessagesOutput|endif|
    \bel <count>new|nnoremap <silent> <buffer> q :bd<cr>|
    \file MessagesOutput|put =execute(\"messages\")|setlocal nomod noma buftype=nofile|0goto
  command! ProfileStart profile start ~/nvim_profile.log|profile func *|profile file *
  command! ProfileStop profile stop
  command! -nargs=* CSystem cexpr system(<q-args>)|copen

  " Functions
  function LastSavedSession(A,L,P)
    return substitute(
      \ globpath("~/.config/nvim/session", "_last_"..a:A.."*.vim"),
      \ "[^\n]*/_last_\\([^\n]*\\)\\.vim", "\\=submatch(1)", "g")
  endfunction
  function Getcwdhead()
    return luaeval("vim.fn.getcwd():gsub('.*/', '')")
  endfunction
]])
api.nvim_create_autocmd({ "FileType" }, {
  group = "initAutoGroup",
  pattern = {"*"},
  callback = function(ev)
    if bo.filetype == 'sh' then
      vim.opt_local.spell = true
      vim.cmd[[
  setlocal iskeyword+=$ iskeyword+={ iskeyword+=}
  nnoremap <buffer> * :let @/=substitute(expand('<cword>'),'^\$\?{\?','$\\?{\\?',"").'}\?'<CR>n
  nnoremap <buffer> # ?<C-R>=substitute(expand('<cword>'),'^\$\?{\?','$\\={\\=',"")<CR>}\=<CR>
      ]]
    elseif bo.filetype == 'php' or bo.filetype == 'htmldjango' then
      vim.opt_local.spell = true
      vim.cmd[[
  setlocal iskeyword+=$
  nnoremap <buffer> * :let @/='\<$\?'.substitute(expand('<cword>'),'^\$','',"").'\>'<CR>n
  nnoremap <buffer> # ?\<$\=<C-R>=substitute(expand('<cword>'),'^\$','',"")<CR>\><CR>
      ]]
    elseif bo.filetype == 'qf' then
      vim.keymap.set('n', '<A-CR>', '<CR>:cclose<cr>', {
        buffer = ev.buf,
        noremap = true,
        silent = true,
      })
      vim.keymap.set(
        'n', '<leader><CR>',
        ':let swbTMP=&switchbuf|set switchbuf=vsplit<cr><CR>:let &switchbuf=swbTMP|unlet swbTMP<cr>', {
        buffer = ev.buf,
        noremap = true,
        silent = true,
      })
    elseif bo.filetype == '' or bo.filetype == 'log' then
      vim.opt_local.spell = false
    else
      vim.opt_local.spell = true
    end
  end
})
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
  callback = function(ev)
    if bo.buftype == '' or bo.buftype == 'acwrite' then
      if wo.number ~= true then
        wo.number = true
      end
    elseif bo.buftype == 'help' then
      vim.keymap.set('n', 'q', '<cmd>bdelete<cr>', {
        buffer = ev.buf,
        noremap = true,
        silent = true,
      })
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
    if o.cmdheight == 0 then
      o.cmdheight = 1
    end
  end
})
api.nvim_create_autocmd({ "CmdlineLeave" }, {
  group = "initAutoGroup",
  pattern = {"*"},
  callback = function()
    if o.cmdheight == 1 then
      o.cmdheight = 0
    end
  end
})
do
  local filetype_max_line_length = {
        c = 80,
        java = 110,
        org = 80,
        javascript = 100,
        lua = 80,
        php = 80,
        python = 79,
        rs = 100,
        typescript = 100,
  }
  api.nvim_create_autocmd({ "TextChanged", "InsertLeave" }, {
    group = "initAutoGroup",
    pattern = {"*"},
    callback = function(ev)
      local columns = filetype_max_line_length[bo.filetype]
      if columns then
        local last_pos = fn.getpos("']")
        if last_pos[4] ~= 0 then
          return
        end
        local last = last_pos[2]
        local first = fn.getpos("'[")[2]
        if wo.colorcolumn == '' then
          local lines = api.nvim_buf_get_lines(ev.buf, first - 1, last, false)
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
              ev.buf, "r", first + max_index - 1, max_len - 1, {}
            )
            vim.opt_local.colorcolumn = tostring(columns + 1)
          end
        else
          local max_mark = api.nvim_buf_get_mark(ev.buf, "r")[1]
          if max_mark ~= 0 then
            if max_mark + 1 < first or last < max_mark then
              return
            end
            local lines = api.nvim_buf_get_lines(
              ev.buf, max_mark - 1, max_mark + 1, false
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
          api.nvim_buf_del_mark(ev.buf, "r")
          local first = vim.fn.line("w0")
          lines = api.nvim_buf_get_lines(
            ev.buf, first - 1, vim.fn.line("w$"), true
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
              ev.buf, "r", first + max_index - 1, max_len - 1, {}
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
    local messages = { 'fidget.nvim will soon be rewritten. ' }
    for _, message in ipairs(messages) do
      if msg:sub(1, #message) == message then
        return
      end
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
  { desc = 'Toggle virtual edit' })
mapset('t', '<Esc><Esc>', '<C-\\><C-n>')
mapset('t', '<C-q>', '<C-\\><C-n><C-w><C-w>')
mapset('x', 'zx', "<Esc>:silent 1,'<-1fold<cr>:silent '>+1,$fold<CR>",
{ desc = 'Fold except region' })
mapset('x', '\\p', '"_dP')
mapset('n', '\\C', '"_C')
mapset({ 'n', 'x' }, '\\c', '"_c')
mapset('n', '\\D', '"_D')
mapset({ 'n', 'x' }, '\\d', '"_d')
mapset('n', '\\X', '"_X')
mapset({ 'n', 'x' }, '\\x', '"_x')
-- added in vim version 0.8.0
-- map('x', '<leader>*', '"0y/<C-R>0<CR>', noremap)
-- map('x', '<leader>#', '"0y?<C-R>0<CR>', noremap)
mapset('n', '<C-a>', function()
  local inc = require'increases_at_cursor'
  mapset('n', '<C-a>', inc.increase_at_cursor, { desc = 'Increase at cursor' })
  mapset('n', '<C-x>', inc.decrease_at_cursor, { desc = 'Decrease at cursor' })
  inc.increase_at_cursor()
end, { desc = 'Increase at cursor' })
mapset('n', '<C-x>', function()
  local inc = require'increases_at_cursor'
  mapset('n', '<C-a>', inc.increase_at_cursor, { desc = 'Increase at cursor' })
  mapset('n', '<C-x>', inc.decrease_at_cursor, { desc = 'Decrease at cursor' })
  inc.decrease_at_cursor()
end, { desc = 'Decrease at cursor' })
mapset('n', '<C-q>', '@:')
mapset('n', 'zdc', ':%g/^[ \t]*class /normal! zc<CR>')
mapset('n', 'zdf', ':%g/^[ \t]*\\(function\\|def\\) /normal! zc<CR>')
mapset('n', '<leader><Return>', 'i<CR><C-\\><C-n>')
mapset('n', '<C-W>*', win_double_width, { desc = 'Double width win' })
mapset('n', '<C-W>/', win_half_width, { desc = 'Half width win' })
mapset('n', '<C-W>0', '<CMD>copen<CR>', { desc = 'Goto quickfix' })
mapset('n', '<C-W>1', function() set_curr_win(1) end, { desc = 'Goto win 1' })
mapset('n', '<C-W>2', function() set_curr_win(2) end, { desc = 'Goto win 2' })
mapset('n', '<C-W>3', function() set_curr_win(3) end, { desc = 'Goto win 3' })
mapset('n', '<C-W>4', function() set_curr_win(4) end, { desc = 'Goto win 4' })
mapset('n', '<C-W>5', function() set_curr_win(5) end, { desc = 'Goto win 5' })
mapset('n', '<C-W>6', function() set_curr_win(6) end, { desc = 'Goto win 6' })
mapset('n', '<C-W>7', function() set_curr_win(7) end, { desc = 'Goto win 7' })
mapset('n', '<C-W>8', function() set_curr_win(8) end, { desc = 'Goto win 8' })
mapset('n', '<C-W>9', function() set_curr_win(9) end, { desc = 'Goto win 9' })
mapset('n', '<C-W>e', function()
  o.signcolumn = o.signcolumn == 'number' and 'auto:1' or 'number'
end, { desc = 'Toggle sign column' })
mapset('n', '<C-W>w', win_fit_width_to_content, { desc = 'Fit width to content' })
mapset('n', '<C-W>W', win_fit_filetype_width, { desc = 'Width by filetype' })
mapset('n', '<leader>CC', '<CMD>lclose<CR>', { desc = 'Close location list' })
mapset('n', '<leader>Cc', '<CMD>cclose<CR>', { desc = 'Close quickfix' })
mapset('n', '<leader>CO', '<CMD>lopen<CR>', { desc = 'Open location list' })
mapset('n', '<leader>Co', '<CMD>copen<CR>', { desc = 'Open quickfix' })
mapset('n', '<leader>CF', '<CMD>lfirst<CR>', { desc = 'First location list' })
mapset('n', '<leader>Cf', '<CMD>cfirst<CR>', { desc = 'First quickfix' })
mapset('n', '<leader>CN', '<CMD>lnext<CR>', { desc = 'Next location list' })
mapset('n', '<leader>Cn', '<CMD>cnext<CR>', { desc = 'Next quickfix' })
mapset('n', '<leader>CP', '<CMD>lprevious<CR>', { desc = 'Previous location list' })
mapset('n', '<leader>Cp', '<CMD>cprevious<CR>', { desc = 'Previous quickfix' })
mapset('n', '<leader>CL', '<CMD>llast<CR>', { desc = 'Last location list' })
mapset('n', '<leader>Cl', '<CMD>clast<CR>', { desc = 'Last quickfix' })
mapset('n', '<A-y>',
  ':registers "0123456789abcdefghijklmnopqrstuvwxyz*+.<CR>',
  noremap_silent)
mapset('n', '<leader>Wc', ':lcd %:h', { desc = 'Local cd file folder' })
mapset('n', '<leader>We', ':e <C-R>=expand("%:p:h") . "/" <CR>', { desc = 'Edit from file folder' })
mapset('n', '<leader>Ww', ':w <C-R>=expand("%:p:h") . "/" <CR>', { desc = 'Write to file folder' })
mapset('n', '<leader>Ws', ':sp <C-R>=expand("%:p:h") . "/" <CR>', { desc = 'Split from file folder' })
mapset('n', '<leader>Wv', ':vs <C-R>=expand("%:p:h") . "/" <CR>', { desc = 'VSplit from file folder' })
mapset('n', '<leader>Wt', ':terminal <C-R>=expand("%:p:h") . "/" <CR>',
{ desc = 'Terminal from file folder' })
mapset('n', '<leader>Yfn', ':let @+=expand("%")<CR>', { desc = 'Yank file relative name' })
mapset('n', '<leader>Yfp', ':let @+=expand("%:p")<CR>', { desc = 'Yank file absolute path' })
mapset('n', '<leader>Yfd', ':let @+=expand("%:p:h")<CR>', { desc = 'Yank file directory' })
mapset('n', '<leader>Pp', ':put =execute(\\"\\")<Left><Left><Left>', { desc = 'Put command' })
mapset(
  'n', '<leader>Pv', ':vnew<CR>:put =execute(\\"\\")<Left><Left><Left>',
  { desc = 'Put command vnew win'}
)
mapset(
  'n', '<leader>Ps', ':new<CR>:put =execute(\\"\\")<Left><Left><Left>',
  { desc = 'Put command new win'}
)
mapset('n', '<C-l>',
  ':hi Normal ctermbg=NONE guibg=NONE|nohlsearch|diffupdate<CR><C-L>')
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
mapset({'i', 'c'}, '<C-y>', '<C-r>+', noremap_silent)
mapset('i', '<C-x><C-a>', '<C-a>', noremap_silent)
mapset('i', '<C-a>', '<Home>', noremap_silent)
mapset('i', '<C-e>', '<End>', noremap_silent)
mapset('i', '<C-d>', '<Del>', noremap_silent)
mapset('i', '<A-d>', '<C-o>dw', noremap_silent)
-- mapset('i', '<A-v>', '<PageUp>', noremap_silent)
-- mapset('i', '<C-v>', '<PageDown>', noremap_silent)
mapset('i', '<C-k>', '<C-o>D', noremap_silent)
-- Both <BS> and <C-BS> sends ^? on terminals
-- <C-H> equals <C-BS> on st
-- mapset('i', '<C-H>', '<Left><C-o>dvb', noremap_silent)
mapset('i', '<A-BS>', '<Left><C-o>dvb', noremap_silent)
-- <C-u> already exists
mapset('c', '<A-p>', '<C-p>')
mapset('c', '<A-n>', '<C-n>')
mapset('c', '<A-b>', '<C-f>b<C-c>')
mapset('c', '<A-f>', '<C-f>e<C-c><Right>')
mapset('c', '<C-b>', '<Left>')
mapset('c', '<C-f>', function()
  -- 'getcmdpos()>strlen(getcmdline())?&cedit:"\\<Lt>Right>"'
  if vim.fn.getcmdpos() > vim.fn.getcmdline():len() then
    return '<C-f>'
  else
    return '<Right>'
  end
end, noremap_expr)
mapset('c', '<C-x><C-a>', '<C-a>')
mapset('c', '<C-a>', '<Home>')
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
mapset('c', '<A-d>', '<C-f>dw<C-c>')
mapset('c', '<C-k>', '<C-f>D<C-c><Right>')
mapset('c', '<A-BS>', function()
  if vim.fn.getcmdpos() > vim.fn.getcmdline():len() then
    return '<C-f>dvb<C-c><Right>'
  else
    return '<C-f>db<C-c>'
  end
end, noremap_expr)
