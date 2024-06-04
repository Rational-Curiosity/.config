-- vim.lsp.set_log_level('debug')
local api = vim.api
local opt = vim.opt
local o = vim.o
local bo = vim.bo
local wo = vim.wo
local g = vim.g
local noremap_silent = { noremap = true, silent = true }
local noremap_expr = { noremap = true, expr = true }
local noremap = { noremap = true }
-- local map = api.nvim_set_keymap
local mapset = vim.keymap.set
local fn = vim.fn
local config_path = fn.stdpath("config")

g.editorconfig = false
g.tokyonight_style = "night"
g.tokyonight_transparent = true
o.shortmess = o.shortmess .. "AsScIW"
o.updatetime = 2000
o.cmdheight = 0
o.showcmdloc = "statusline"
o.showmode = false
o.fileencoding = "utf-8"
o.redrawtime = 150
o.synmaxcol = 400

-- opt.lazyredraw = true  -- It is only meant to be set temporarily
o.encoding = "utf-8"
o.tabstop = 4
o.shiftwidth = 0
o.softtabstop = 2
o.expandtab = true
o.list = true
opt.listchars = {
  tab = "⇤·⇥",
  eol = "↲",
  nbsp = "␣",
  trail = "•",
  extends = "⮞",
  precedes = "⮜",
}
o.conceallevel = 2
-- o.concealcursor = "nc"
o.cursorline = true
o.wrap = false
o.scrolloff = 0 -- Screen lines to keep above & below the cursor
o.sidescrolloff = 1 -- Screen columns to keep to the left & right of the cursor
o.virtualedit = "block"
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
o.shada = "!,'500,/100,:250,<50,@100,h,s8"
o.shadafile = config_path .. "/shada/main.shada"
o.history = 600
o.spelllang = "en_us,es"
o.spellfile = config_path .. "/spell/en-es.utf-8.add"

-- Programs
o.grepprg = "rg --vimgrep --smart-case --follow"
-- opt.clipboard:prepend('unnamedplus')
o.ignorecase = true
o.smartcase = true
o.shell = "sh"
vim.env.SHELL = "sh"
g.python3_host_prog = fn.executable("/usr/local/bin/python3") == 1
  and "/usr/local/bin/python3"
  or "/usr/bin/python3"
g.netrw_scp_cmd = "yad --separator= --form --field=Password:H|sshpass scp -q"
g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0

-- UNDO
o.undodir = config_path .. "/undo"
o.undofile = true
o.undolevels = 700

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
  autocmd TermOpen term://* setlocal scrollback=100000 nospell nonumber norelativenumber|startinsert
augroup end

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
cabbrev <expr> T getcmdpos() == 2 && getcmdtype() == ':' ? 'Telescope' : 'T'
cabbrev <expr> VS getcmdpos() == 3 && getcmdtype() == ':' ? 'vs '.expand('%:p:h') : 'VS'
cabbrev <expr> SP getcmdpos() == 3 && getcmdtype() == ':' ? 'sp '.expand('%:p:h') : 'SP'
cabbrev <expr> vh getcmdpos() == 3 && getcmdtype() == ':' ? 'vert help' : 'vh'
cabbrev <expr> bdn getcmdpos() == 4 && getcmdtype() == ':' ? 'bn<bar>bd#' : 'bdn'
cabbrev <expr> bdp getcmdpos() == 4 && getcmdtype() == ':' ? 'bp<bar>bd#' : 'bdp'
cabbrev <expr> Mess getcmdpos() == 5 && getcmdtype() == ':' ? 'Messages' : 'Mess'
cabbrev <expr> lp getcmdpos() == 3 && getcmdtype() == ':' ? 'lua print' : 'lp'
cabbrev <expr> lpi getcmdpos() == 4 && getcmdtype() == ':' ? 'lua print(vim.inspect' : 'lpi'
cabbrev <expr> dn getcmdpos() == 3 && getcmdtype() == ':' ? 'DiagNext' : 'dn'
cabbrev <expr> dp getcmdpos() == 3 && getcmdtype() == ':' ? 'DiagPrev' : 'dp'
cabbrev <expr> te getcmdpos() == 3 && getcmdtype() == ':' ? 'Term' : 'te'
cabbrev <expr> ter getcmdpos() == 4 && getcmdtype() == ':' ? 'Term' : 'ter'
cabbrev <expr> term getcmdpos() == 5 && getcmdtype() == ':' ? 'Term' : 'term'
cabbrev <expr> termi getcmdpos() == 6 && getcmdtype() == ':' ? 'Term' : 'termi'
cabbrev <expr> termin getcmdpos() == 7 && getcmdtype() == ':' ? 'Term' : 'termin'
cabbrev <expr> termina getcmdpos() == 8 && getcmdtype() == ':' ? 'Term' : 'termina'
cabbrev <expr> terminal getcmdpos() == 9 && getcmdtype() == ':' ? 'Term' : 'terminal'

" Commands
command! -complete=custom,LastSavedSession -nargs=? L source ~/.config/nvim/session/_last_<args>.vim
command! -complete=custom,LastSavedSession -nargs=? Q mksession! ~/.config/nvim/session/_last_<args>.vim|qall
command! -complete=custom,LastSavedSession -nargs=? S mksession! ~/.config/nvim/session/_last_<args>.vim
command! -complete=shellcmd -nargs=* CSystem cexpr system(<q-args>)|copen
command! -count=1 DiagNext for i in range(<count>)|call luaeval('vim.diagnostic.goto_next()')|endfor
command! -count=1 DiagPrev for i in range(<count>)|call luaeval('vim.diagnostic.goto_prev()')|endfor
command! -count=10 -nargs=* HTerm botright <count>split|exe "Term ".<q-args>|setlocal wfh|exe "normal \<c-w>="
command! -count=7 -complete=command -nargs=* B exe "if bufexists('*".<q-args>."*')|
  \sil! bdelete *".<q-args>."*|endif|bel <count>new|nnoremap <silent> <buffer> q :bd<cr>|
  \file *".<q-args>."*|put =execute(\\\"".<q-args>."\\\")|setlocal nomod noma buftype=nofile|0goto"
command! -count=7 Messages if bufexists("*Messages*")|
  \sil! bdelete *Messages*|endif|bel <count>new|nnoremap <silent> <buffer> q :bd<cr>|
  \file *Messages*|put =execute(\"messages\")|setlocal nomod noma buftype=nofile|0goto
command! -count=72 -nargs=* VTerm vert botright <count>split|exe "Term ".<q-args>|setlocal wfw|exe "normal \<c-w>="
command! -nargs=* HistDel call histdel(<f-args>)|wshada!
command! -nargs=? HistDelLast call histdel(<q-args> ?? ':', <q-args> ? -1 : -2)
command! -nargs=* Term set shell=fish|exe "term ".<q-args>|set shell=sh
command! -nargs=? Cd exec 'cd' fnameescape(finddir(<q-args> ?? '.git/..', escape(expand('%:p:h'), ' ').';'))
command! -nargs=? Lcd exec 'lcd' fnameescape(finddir(<q-args> ?? '.git/..', escape(expand('%:p:h'), ' ').';'))
command! ProfileStart profile start ~/nvim_profile.log|profile func *|profile file *
command! ProfileStop profile stop
command! SetStatusline lua vim.go.statusline = "%{%v:lua.require'lualine'.statusline()%}"

" Functions
function Params(...)
  for param in a:000
    echo param
  endfor
endfunction
function LastSavedSession(A,L,P)
  return substitute(
    \ globpath("~/.config/nvim/session", "_last_"..a:A.."*.vim"),
    \ "[^\n]*/_last_\\([^\n]*\\)\\.vim", "\\=submatch(1)", "g")
endfunction
function Getcwdhead()
  return luaeval("vim.fn.getcwd():gsub('.*/', '')")
endfunction
nm <silent> <F1> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name")
  \ . '> trans<' . synIDattr(synID(line("."),col("."),0),"name")
  \ . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name")
  \ . ">"<CR>
]])
do
  local tabstop2_ft = {
    c = true,
    cpp = true,
    css = true,
    html = true,
    javascript = true,
    javascriptreact = true,
    json = true,
    lua = true,
    rust = true,
    typescript = true,
    typescriptreact = true,
  }
  local numbersign_ft = {
    hjson = true,
    sql = true,
    mysql = true,
    plsql = true,
  }
  api.nvim_create_autocmd({ "FileType" }, {
    group = "initAutoGroup",
    pattern = { "*" },
    callback = function(ev)
      if bo.filetype == "sh" then
        vim.opt_local.spell = true
        vim.cmd([[
        setlocal iskeyword+=$ iskeyword+={ iskeyword+=}
        nnoremap <buffer> * :let @/=substitute(expand('<cword>'),'^\$\?{\?','$\\?{\\?',"").'}\?'<CR>n
        nnoremap <buffer> # ?<C-R>=substitute(expand('<cword>'),'^\$\?{\?','$\\={\\=',"")<CR>}\=<CR>
        ]])
      elseif tabstop2_ft[bo.filetype] then
        vim.opt_local.spell = true
        o.tabstop = 2
      elseif numbersign_ft[bo.filetype] then
        vim.opt_local.spell = true
        vim.opt_local.commentstring = "# %s"
      elseif bo.filetype == "php" or bo.filetype == "htmldjango" then
        vim.opt_local.spell = true
        vim.cmd([[
        setlocal iskeyword+=$
        nnoremap <buffer> * :let @/='\<$\?'.substitute(expand('<cword>'),'^\$','',"").'\>'<CR>n
        nnoremap <buffer> # ?\<$\=<C-R>=substitute(expand('<cword>'),'^\$','',"")<CR>\><CR>
        ]])
      elseif bo.filetype == "qf" then
        vim.opt_local.spell = false
        vim.keymap.set("n", "<A-CR>", "<CR>:cclose<CR>", {
          buffer = ev.buf,
          noremap = true,
          silent = true,
        })
        vim.keymap.set(
          "n",
          "<leader><CR>",
          ":let swbTMP=&switchbuf|set switchbuf=vsplit<CR><CR>:let &switchbuf=swbTMP|unlet swbTMP<CR>",
          {
            buffer = ev.buf,
            noremap = true,
            silent = true,
          }
        )
      elseif bo.filetype == "" or bo.filetype == "log" then
        vim.opt_local.spell = false
      else
        vim.opt_local.spell = true
      end
    end,
  })
end
api.nvim_create_autocmd({ "BufWinEnter" ,"WinEnter" }, {
  group = "initAutoGroup",
  pattern = { "term://*" },
  callback = function()
    if fn.jobwait({bo.channel}, 0)[1] == -1 then
      api.nvim_command('startinsert')
    end
  end,
})
-- [ Terminal relativenumber
-- api.nvim_create_autocmd({ "TermEnter" }, {
--   group = "initAutoGroup",
--   pattern = { "*" },
--   callback = function()
--     wo.relativenumber = false
--     wo.number = false
--   end,
-- })
-- api.nvim_create_autocmd({ "TermLeave" }, {
--   group = "initAutoGroup",
--   pattern = { "*" },
--   callback = function()
--     wo.number = true
--     wo.relativenumber = true
--   end,
-- })
-- ]
api.nvim_create_autocmd({ "TermClose" }, {
  group = "initAutoGroup",
  pattern = { "*" },
  callback = function(ev)
    api.nvim_command('stopinsert')
    vim.keymap.set("n", "q", "<CMD>bdelete<CR>", {
      buffer = ev.buf,
      noremap = true,
      silent = true,
    })
  end,
})
api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = "initAutoGroup",
  pattern = { "*" },
  callback = function(ev)
    if bo.buftype == "" or bo.buftype == "acwrite" then
      if wo.number ~= true then
        wo.number = true
      end
    elseif bo.buftype == "help" then
      vim.keymap.set("n", "q", "<CMD>bdelete<CR>", {
        buffer = ev.buf,
        noremap = true,
        silent = true,
      })
    end
  end,
})
api.nvim_create_autocmd({ "FocusGained" }, {
  group = "initAutoGroup",
  pattern = { "*" },
  callback = function()
      api.nvim_command('let @"=@+')
  end,
})
api.nvim_create_autocmd({ "FocusLost" }, {
  group = "initAutoGroup",
  pattern = { "*" },
  callback = function()
      api.nvim_command('let @+=@"')
  end,
})
api.nvim_create_autocmd({
  "BufEnter",
  "FocusGained",
  "InsertLeave",
  "CmdlineLeave",
  "WinEnter",
}, {
  group = "initAutoGroup",
  pattern = { "*" },
  callback = function()
    if
      o.nu
      and (bo.buftype == "" or bo.buftype == "acwrite")
      and wo.relativenumber ~= true
    then
      wo.relativenumber = true
    end
  end,
})
api.nvim_create_autocmd({
  "BufLeave",
  "FocusLost",
  "InsertEnter",
  "CmdlineEnter",
  "WinLeave",
}, {
  group = "initAutoGroup",
  pattern = { "*" },
  callback = function()
    if
      o.nu
      and (bo.buftype == "" or bo.buftype == "acwrite")
      and wo.relativenumber ~= false
    then
      wo.relativenumber = false
      -- api.nvim_command("redraw")
    end
  end,
})
do
  local yank_registers = { "r", "s", "t", "u", "v", "w", "x", "y", "z" }
  local function update_yank_ring(register)
    if fn.getreg(register, 1) == fn.getreg(yank_registers[1], 1) then
      return
    end
    local index = #yank_registers
    for i = 1, index - 1 do
      if
        fn.getreg(yank_registers[i], 1)
        == fn.getreg(yank_registers[i + 1], 1)
      then
        index = i
        break
      end
    end
    for i = index, 2, -1 do
      fn.setreg(
        yank_registers[i],
        fn.getreg(yank_registers[i - 1], 1),
        fn.getregtype(yank_registers[i - 1])
      )
    end
    fn.setreg(
      yank_registers[1],
      fn.getreg(register, 1),
      fn.getregtype(register)
    )
  end
  api.nvim_create_autocmd({ "TextYankPost" }, {
    group = "initAutoGroup",
    pattern = { "*" },
    callback = function()
      local yanked = fn.getreg('"', 1)
      if yanked:len() > 1 and yanked ~= fn.getreg("1", 1) then
        update_yank_ring('"')
        vim.highlight.on_yank({ higroup = "Visual", timeout = 300 })
      end
    end,
  })
  api.nvim_create_autocmd({ "FocusGained" }, {
    group = "initAutoGroup",
    pattern = { "*" },
    callback = function()
      update_yank_ring("+")
    end,
  })
end
-- api.nvim_create_autocmd({"CursorHoldI", "CmdlineEnter"}, {
--   group = "initAutoGroup",
--   pattern = {"*"},
--   callback = function()
--     require'cmp'.complete()
--   end
-- })
-- [ Dynamic cmdheight
-- api.nvim_create_autocmd({ "CmdlineEnter" }, {
--   group = "initAutoGroup",
--   pattern = { "*" },
--   callback = function()
--     if o.cmdheight == 0 then
--       o.cmdheight = 1
--     end
--   end,
-- })
-- do
--   local last_cmd_del = false
--   api.nvim_create_autocmd({ "CmdlineLeave" }, {
--     group = "initAutoGroup",
--     pattern = { "*" },
--     callback = function()
--       local cmdline
--       local cmdtype = fn.getcmdtype()
--       if cmdtype == ':' then
--         if last_cmd_del then
--           last_cmd_del = false
--           fn.histdel(':', -1)
--         end
--         cmdline = fn.getcmdline()
--         if cmdline == '' then
--           o.cmdheight = 0
--           return
--         end
--       end
--       api.nvim_command('redir => g:tmp_last_output')
--       fn.timer_start(100, function()
--         api.nvim_command('redir END')
--         local tmp_output = vim.trim(api.nvim_get_var('tmp_last_output'))
--         if cmdtype == '/' or cmdtype == '?' then
--           tmp_output = tmp_output:gsub('^%'..cmdtype..'[^\n]*\n*', '', 1)
--         elseif cmdtype == ':' then
--           tmp_output = tmp_output:gsub('^:[^\n]*\n*', '', 1)
--           if tmp_output:match('^E[0-9][0-9][0-9]: ') then
--             last_cmd_del = true
--           elseif tmp_output == '' and fn.getreg(':') ~= cmdline then
--             fn.histdel(':', -1)
--           end
--         end
--         if tmp_output == '' or select(2, tmp_output:gsub('\n', '')) > 0 then
--           o.cmdheight = 0
--         else
--           fn.timer_start(5000, function() o.cmdheight = 0 end)
--         end
--       end)
--     end,
--   })
-- end
-- ]
do
  local filetype_max_line_length = {
    c = 80,
    java = 110,
    javascript = 100,
    javascriptreact = 100,
    lua = 80,
    org = 80,
    php = 80,
    python = 79,
    rust = 100,
    typescript = 100,
    typescriptreact = 100,
  }
  api.nvim_create_autocmd({ "TextChanged", "InsertLeave" }, {
    group = "initAutoGroup",
    pattern = { "*" },
    callback = function(ev)
      local columns = filetype_max_line_length[bo.filetype]
      if not columns then
        return
      end
      local last_pos = fn.getpos("']")
      if last_pos[4] ~= 0 then
        return
      end
      local last_line = last_pos[2]
      local first_line = fn.getpos("'[")[2]
      if wo.colorcolumn == "" then
        local lines = api.nvim_buf_get_lines(
          ev.buf,
          first_line - 1,
          last_line,
          false
        )
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
            ev.buf,
            "r",
            first_line + max_index - 1,
            max_len - 1,
            {}
          )
          vim.opt_local.colorcolumn = tostring(columns + 1)
        end
      else
        local max_mark = api.nvim_buf_get_mark(ev.buf, "r")[1]
        if max_mark ~= 0 then
          if max_mark + 1 < first_line or last_line < max_mark then
            return
          end
          local lines =
            api.nvim_buf_get_lines(ev.buf, max_mark - 1, max_mark + 1, false)
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
        lines =
          api.nvim_buf_get_lines(ev.buf, first - 1, vim.fn.line("w$"), true)
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
            ev.buf,
            "r",
            first + max_index - 1,
            max_len - 1,
            {}
          )
        else
          vim.opt_local.colorcolumn = ""
        end
      end
    end,
  })
  function _G.win_fit_filetype_width()
    if wo.winfixwidth then
      vim.notify("Fixed width window", vim.log.levels.WARN, {
        title = "win_fit_filetype_width",
      })
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
    api.nvim_command("horizontal wincmd =")
    wo.winfixwidth = false
  end
end
api.nvim_create_autocmd({ "VimLeave" }, {
  group = "initAutoGroup",
  pattern = { "*" },
  callback = function()
    vim.cmd([[
    let @+=@"
    set nomore
    "if exists(':Noice')
    "  Noice all
    "  if &ft == 'noice'
    "    let s:msgs = getline(1, '$')
    "    let s:save = s:msgs != []
    "  else
    "    let s:save = 0
    "  endif
    "else
      let s:msgs = trim(execute('messages'))
      if exists(':Notifications')
        let s:msgs = s:msgs .. execute('Notifications')
      endif
      let s:save = s:msgs != ''
      let s:msgs = split(s:msgs, '\n')
    "endif
    if s:save
      let s:file = stdpath('config') .. '/shada/messages'
      let s:filelist = split(glob(s:file .. '*.txt'), '\n')
      if len(s:filelist) > 4
        call remove(s:filelist, -4, -1)
        for file in s:filelist
          call delete(file)
        endfor
      endif
      call writefile(s:msgs, s:file .. strftime('%Y-%m-%d_%H.%M.%S') .. '.txt')
    endif
    ]])
  end,
})

-- [ Notifications
-- do
--   local orig_notify_once = vim.notify_once
--   local notify_once_messages = {
--     "vim.tbl_add_reverse_lookup is deprecated. ",
--     "vim.lsp.get_active_clients() is deprecated, ",
--     "vim.tbl_islist is deprecated, ",
--   }
--   vim.notify_once = function(msg, level, opts)
--     for _, message in ipairs(notify_once_messages) do
--       if msg:sub(1, #message) == message then
--         return
--       end
--     end
--     orig_notify_once(msg, level, opts)
--   end
-- end
-- ]

-- Global functions
function _G.getcwdhead()
  return fn.getcwd():gsub(".*/", "")
end

function _G.set_next_win(reverse)
  local curr_win = api.nvim_get_current_win()
  local wins = api.nvim_tabpage_list_wins(0)
  if reverse then
    for i = 1, math.floor(#wins / 2) do
      wins[i], wins[#wins - i + 1] = wins[#wins - i + 1], wins[i]
    end
  end
  local last = #wins
  while 1 <= last do
    if wins[1] ~= curr_win then
      table.insert(wins, table.remove(wins, 1))
      last = last - 1
    else
      table.remove(wins, 1)
      break
    end
  end
  for k, win in ipairs(wins) do
    if api.nvim_win_get_config(win).focusable
      and api.nvim_get_option_value(
      "filetype",
      { buf = api.nvim_win_get_buf(win) }
    ) ~= "notify" then
      api.nvim_set_current_win(win)
      break
    end
  end
end

function _G.set_curr_win(index)
  local wins = api.nvim_tabpage_list_wins(0)
  local i = 1
  while i <= #wins do
    if api.nvim_buf_get_name(api.nvim_win_get_buf(wins[i])) == "" then
      table.remove(wins, i)
    else
      i = i + 1
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
    vim.notify("Fixed width window", vim.log.levels.WARN, {
      title = "win_fit_width_to_content",
    })
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
    api.nvim_command("horizontal wincmd =")
    wo.winfixwidth = false
  end
end

function _G.win_fit_height_to_content()
  if wo.winfixheight then
    vim.notify("Fixed height window", vim.log.levels.WARN, {
      title = "win_fit_height_to_content",
    })
    return
  end
  local line_count = api.nvim_buf_line_count(0)
  if line_count >= o.winminheight then
    api.nvim_win_set_height(0, line_count)
    wo.winfixheight = true
    api.nvim_command("vertical wincmd =")
    wo.winfixheight = false
  end
end

function _G.win_half_height()
  api.nvim_win_set_height(0, math.ceil(api.nvim_win_get_height(0) / 2))
end

function _G.win_half_width()
  api.nvim_win_set_width(0, math.ceil(api.nvim_win_get_width(0) / 2))
end

function _G.win_double_height()
  api.nvim_win_set_height(0, api.nvim_win_get_height(0) * 2)
end

function _G.win_double_width()
  api.nvim_win_set_width(0, api.nvim_win_get_width(0) * 2)
end

function _G.switch(_value)
  local _switch = {
    _default_func = nil,
    _functions = {},
  }

  _switch.case = function(value, func)
    _switch._functions[value] = func
    return _switch
  end

  _switch.default = function(func)
    _switch._default_func = func
    return _switch
  end

  _switch.call = function(value)
    local func = _switch._functions[value or _value]
    if func then
      return func()
    elseif _switch._default_func then
      return _switch.default_func()
    end
  end

  _switch.switch = function(value)
    _switch.call(value)
    return _switch
  end

  _switch.reset = function()
    _switch._functions = {}
    _switch._default_func = nil
    return _switch
  end

  return _switch
end

function _G.find_ancestor(filename, path)
  if path then
    if path:sub(1, 1) == "~" then
      path = vim.fn.expand(path)
    elseif path:sub(1, 1) ~= "/" then
      path = vim.fn.fnamemodify(path, ":p")
    end
  else
    path = vim.fn.getcwd()
  end
  while path ~= "/" do
    local filepath = path .. "/" .. filename
    if vim.fn.filereadable(filepath) ~= 0 then
      return filepath
    end
    path = vim.fn.fnamemodify(path, ":h")
  end
  local filepath = path .. filename
  if vim.fn.filereadable(filepath) ~= 0 then
    return filepath
  end
  return nil
end

function _G.append_to_last(...)
  local args = {...}
  local to = table.remove(args)
  for _, from in ipairs(args) do
    for k, v in pairs(from) do
      if to[k] == nil then
        to[k] = v
      end
    end
  end
  return to
end

do
  local region_type = {
    ["v"] = "v",
    ["V"] = "V",
    [""] = "<CTRL-V>",
  }
  function _G.get_region_text()
    local type = region_type[fn.mode()] or fn.visualmode()
    if type == "" then
      return nil
    end
    return table.concat(vim.fn.getregion(
      fn.getpos("'<"),
      fn.getpos("'>"),
      { type = type }
    ), "\n")
  end
end

-- User Commands
api.nvim_create_user_command(
  "InspectOpts",
  function(opts)
    print(vim.inspect(opts))
  end,
  {
    range = true, bar = true, nargs = "*",
  }
)
api.nvim_create_user_command(
  "SendToTerm",
  function(opts)
    local text
    if opts.range == 0 then
      text = api.nvim_get_current_line()
    else
      text = get_region_text()
      if not text then
        vim.notify("Range not defined", vim.log.levels.ERROR, {
          title = "SendToTerm",
        })
        return
      end
    end
    local id = tonumber(opts.args)
    if not id then
      for _, chan in ipairs(api.nvim_list_chans()) do
        if chan.mode == "terminal" then
          id = chan.id
        end
      end
    end
    return api.nvim_chan_send(id, text .. "\n")
  end,
  {
    range = true, bar = true, nargs = "?",
    complete = function(arg_lead, cmd_line, cursor_pos)
      local result = {}
      for _, chan in ipairs(api.nvim_list_chans()) do
        if chan.mode == "terminal" then
          table.insert(result, tostring(chan.id))
        end
      end
      return result
    end,
    desc = "Send region or line to terminal",
  }
)

-- Keymap bindings
for _, v in ipairs({'n', 'N', 'K'}) do
  mapset("n", v, function()
    local status, output = pcall(
      api.nvim_cmd,
      { cmd = "norm", args = { v }, bang = true },
      { output = true }
    )
    if not status then
      vim.notify(output, vim.log.levels.ERROR, { title = v })
    end
  end)
end
mapset("n", "ZZ", "<Nop>")
mapset("n", "Q", function()
  opt.lazyredraw = true
  local ok, noice = pcall(require, "noice")
  if ok then noice.disable() end
  vim.cmd([[
  syntax off
  noautocmd norm! ]] .. vim.v.count1 .. [[@q
  syntax on
  ]])
  if ok then noice.enable() end
  opt.lazyredraw = false
end)
for _, v in ipairs({ "@m", "@n", "@o", "@p", "@q" }) do
  mapset("n", v, function()
    opt.lazyredraw = true
    local ok, noice = pcall(require, "noice")
    if ok then noice.disable() end
    vim.cmd([[
    syntax off
    norm! ]] .. vim.v.count1 .. v .. '\
    syntax on')
    if ok then noice.enable() end
    opt.lazyredraw = false
  end)
end
do
  local virtualedits = { "block", "insert", "all", "onemore", "none" }
  local virtualedits_idx = {
    block = 2,
    insert = 3,
    all = 4,
    onemore = 5,
    none = 1,
    NONE = 1,
  }
  mapset(
    "",
    "<leader>V",
    function()
      o.virtualedit = virtualedits[virtualedits_idx[o.virtualedit]]
      vim.notify("Virtualedit = " .. o.virtualedit, vim.log.levels.INFO, {
        title = "Option",
      })
    end,
    { desc = "Cycle virtual edit" }
  )
end
mapset("t", "<Esc><Esc>", "<C-\\><C-n>")
mapset("t", "<C-q>", "<C-\\><C-n><C-w><C-w>")
mapset(
  "x",
  "zx",
  "<ESC>:silent 1,'<-1fold<CR>:silent '>+1,$fold<CR>",
  { desc = "Fold except region" }
)
mapset("x", "\\p", '"_dP')
mapset("n", "\\C", '"_C')
mapset({ "n", "x" }, "\\c", '"_c')
mapset("n", "\\D", '"_D')
mapset({ "n", "x" }, "\\d", '"_d')
mapset("n", "\\X", '"_X')
mapset({ "n", "x" }, "\\x", '"_x')
-- added in vim version 0.8.0
-- map('x', '<leader>*', '"0y/<C-R>0<CR>', noremap)
-- map('x', '<leader>#', '"0y?<C-R>0<CR>', noremap)
mapset("n", "<leader>*", '<CMD>let @"=@*<CR>')
mapset("n", "<leader>+", '<CMD>let @"=@+<CR>')
mapset("n", "<leader>-", '<CMD>let @"=@-<CR>')
mapset("n", '<leader>"', '<CMD>let @+=@"<CR>')
mapset({ "n", "x" }, "<leader>y", '"+y')
mapset("n", "<leader>Y", '"+y$')
mapset({ "n", "x" }, "<leader>p", '"+p')
mapset({ "n", "x" }, "<leader>P", '"+P')
mapset("n", '<leader><space>', '/\\s\\+$<CR>')
mapset("n", "<leader>tc", function()
  o.clipboard = o.clipboard == "" and "unnamedplus" or ""
end, { desc = "Toggle clipboard" })
mapset("n", "<C-a>", function()
  local inc = require("increases_at_cursor")
  mapset("n", "<C-a>", inc.increase_at_cursor, { desc = "Increase at cursor" })
  mapset("n", "<C-x>", inc.decrease_at_cursor, { desc = "Decrease at cursor" })
  inc.increase_at_cursor()
end, { desc = "Increase at cursor" })
mapset("n", "<C-x>", function()
  local inc = require("increases_at_cursor")
  mapset("n", "<C-a>", inc.increase_at_cursor, { desc = "Increase at cursor" })
  mapset("n", "<C-x>", inc.decrease_at_cursor, { desc = "Decrease at cursor" })
  inc.decrease_at_cursor()
end, { desc = "Decrease at cursor" })
mapset({ "n", "x" }, "<A-.>", "@:")
mapset("n", "zdc", ":%g/^[ \t]*class /normal! zc<CR>",
  { desc = "Fold all classes" })
mapset(
  "n",
  "zdf",
  ":%g/^[ \t]*\\(def\\|fn\\|function\\|func\\) /normal! zc<CR>",
  { desc = "Fold all functions" }
)
mapset("n", "<leader><Return>", "i<CR><C-\\><C-n>")
mapset("n", "<C-W>*h", win_double_height, { desc = "Double win height" })
mapset("n", "<C-W>*w", win_double_width, { desc = "Double win width" })
mapset("n", "<C-W>/h", win_half_height, { desc = "Half win height" })
mapset("n", "<C-W>/w", win_half_width, { desc = "Half win width" })
mapset("n", "<C-W>0", "<CMD>copen<CR>", { desc = "Goto quickfix" })
mapset("n", "<C-W>1", function()
  set_curr_win(1)
end, { desc = "Goto win 1" })
mapset("n", "<C-W>2", function()
  set_curr_win(2)
end, { desc = "Goto win 2" })
mapset("n", "<C-W>3", function()
  set_curr_win(3)
end, { desc = "Goto win 3" })
mapset("n", "<C-W>4", function()
  set_curr_win(4)
end, { desc = "Goto win 4" })
mapset("n", "<C-W>5", function()
  set_curr_win(5)
end, { desc = "Goto win 5" })
mapset("n", "<C-W>6", function()
  set_curr_win(6)
end, { desc = "Goto win 6" })
mapset("n", "<C-W>7", function()
  set_curr_win(7)
end, { desc = "Goto win 7" })
mapset("n", "<C-W>8", function()
  set_curr_win(8)
end, { desc = "Goto win 8" })
mapset("n", "<C-W>9", function()
  set_curr_win(9)
end, { desc = "Goto win 9" })
mapset("n", "<C-W><C-W>", set_next_win, { desc = "Go to next win" })
mapset("n", "<C-W>W", function()
  set_next_win(true)
end, { desc = "Go to prev win" })
mapset("n", "<C-W>e", function()
  o.signcolumn = o.signcolumn == "number" and "auto:1" or "number"
end, { desc = "Toggle sign column" })
mapset("n", "<C-W>E", function()
  local signcolumn = o.signcolumn == "number" and "auto:1" or "number"
  for _, win in pairs(api.nvim_list_wins()) do
    api.nvim_win_set_option(win, "signcolumn", signcolumn)
  end
end, { desc = "Toggle sign column all windows" })
mapset(
  "n",
  "<C-W>fw",
  win_fit_width_to_content,
  { desc = "Fit width to content" }
)
mapset(
  "n",
  "<C-W>fh",
  win_fit_height_to_content,
  { desc = "Fit height to content" }
)
mapset("n", "<C-W>F", win_fit_filetype_width, { desc = "Width by filetype" })
mapset("n", "<leader>CC", "<CMD>lclose<CR>", { desc = "Close location list" })
mapset("n", "<leader>Cc", "<CMD>cclose<CR>", { desc = "Close quickfix" })
mapset("n", "<leader>CO", "<CMD>lopen<CR>", { desc = "Open location list" })
mapset("n", "<leader>Co", "<CMD>copen<CR>", { desc = "Open quickfix" })
mapset("n", "<leader>CF", "<CMD>lfirst<CR>", { desc = "First location list" })
mapset("n", "<leader>Cf", "<CMD>cfirst<CR>", { desc = "First quickfix" })
mapset("n", "<leader>CN", "<CMD>lnext<CR>", { desc = "Next location list" })
mapset("n", "<leader>Cn", "<CMD>cnext<CR>", { desc = "Next quickfix" })
mapset(
  "n",
  "<leader>CP",
  "<CMD>lprevious<CR>",
  { desc = "Previous location list" }
)
mapset("n", "<leader>Cp", "<CMD>cprevious<CR>", { desc = "Previous quickfix" })
mapset("n", "<leader>CL", "<CMD>llast<CR>", { desc = "Last location list" })
mapset("n", "<leader>Cl", "<CMD>clast<CR>", { desc = "Last quickfix" })
mapset(
  "n",
  "<A-y>",
  ':registers "0123456789abcdefghijklmnopqrstuvwxyz*+.<CR>',
  noremap_silent
)
mapset("n", "<leader>Wc", ":lcd %:h", { desc = "Local cd file folder" })
mapset(
  "n",
  "<leader>We",
  ':e <C-R>=expand("%:p:h") . "/" <CR>',
  { desc = "Edit from file folder" }
)
mapset(
  "n",
  "<leader>Ww",
  ':w <C-R>=expand("%:p:h") . "/" <CR>',
  { desc = "Write to file folder" }
)
mapset(
  "n",
  "<leader>Ws",
  ':sp <C-R>=expand("%:p:h") . "/" <CR>',
  { desc = "Split from file folder" }
)
mapset(
  "n",
  "<leader>Wv",
  ':vs <C-R>=expand("%:p:h") . "/" <CR>',
  { desc = "VSplit from file folder" }
)
mapset(
  "n",
  "<leader>Wt",
  ':terminal <C-R>=expand("%:p:h") . "/" <CR>',
  { desc = "Terminal from file folder" }
)
mapset(
  "n",
  "<leader>Fn",
  '<CMD>let @+=expand("%")<CR>',
  { desc = "Yank file relative name" }
)
mapset(
  "n",
  "<leader>Fp",
  '<CMD>let @+=expand("%:p")<CR>',
  { desc = "Yank file absolute path" }
)
mapset(
  "n",
  "<leader>Fd",
  '<CMD>let @+=expand("%:p:h")<CR>',
  { desc = "Yank file directory" }
)
mapset(
  "n",
  "<leader>Xp",
  ':put =execute(\\"\\")<Left><Left><Left>',
  { desc = "Put command" }
)
mapset(
  "n",
  "<leader>Xv",
  ':vnew<CR>:put =execute(\\"\\")<Left><Left><Left>',
  { desc = "Put command vnew win" }
)
mapset(
  "n",
  "<leader>Xs",
  ':new<CR>:put =execute(\\"\\")<Left><Left><Left>',
  { desc = "Put command new win" }
)
mapset(
  "n",
  "<C-l>",
  "<CMD>hi Normal ctermbg=NONE guibg=NONE|nohlsearch|diffupdate<CR><C-L>"
)
mapset(
  "n",
  "<leader>S:",
  ":mkview! ~/.config/nvim/session/_view.vim<CR>:bn|bd#",
  noremap
)
mapset(
  "n",
  "<leader>S.",
  "<CMD>source ~/.config/nvim/session/_view.vim<CR>",
  noremap
)
mapset(
  "n",
  "<leader>S_",
  "<CMD>mksession! ~/.config/nvim/session/_last.vim<CR>",
  noremap
)
mapset(
  "n",
  "<leader>S-",
  "<CMD>source ~/.config/nvim/session/_last.vim<CR>",
  noremap
)
mapset(
  "n",
  "<leader>SS",
  ":mksession! ~/.config/nvim/session/.vim<Left><Left><Left><Left>",
  noremap
)
mapset(
  "n",
  "<leader>Ss",
  ":mksession ~/.config/nvim/session/.vim<Left><Left><Left><Left>",
  noremap
)
mapset(
  "n",
  "<leader>SV",
  ":mkview! ~/.config/nvim/session/.vim<Left><Left><Left><Left>",
  noremap
)
mapset(
  "n",
  "<leader>Sv",
  ":mkview ~/.config/nvim/session/.vim<Left><Left><Left><Left>",
  noremap
)
mapset("n", "<leader>Sl", ":source ~/.config/nvim/session/", noremap)
mapset(
  "n",
  "<leader>SWS",
  ":mksession! ~/.config/nvim/session/<C-R>=v:lua.getcwdhead()<CR>-.vim<Left><Left><Left><Left>",
  noremap
)
mapset(
  "n",
  "<leader>SWs",
  ":mksession ~/.config/nvim/session/<C-R>=v:lua.getcwdhead()<CR>-.vim<Left><Left><Left><Left>",
  noremap
)
mapset(
  "n",
  "<leader>SWV",
  ":mkview! ~/.config/nvim/session/<C-R>=v:lua.getcwdhead()<CR>-.vim<Left><Left><Left><Left>",
  noremap
)
mapset(
  "n",
  "<leader>SWv",
  ":mkview ~/.config/nvim/session/<C-R>=v:lua.getcwdhead()<CR>-.vim<Left><Left><Left><Left>",
  noremap
)
mapset(
  "n",
  "<leader>SWl",
  ":source ~/.config/nvim/session/<C-R>=v:lua.getcwdhead()<CR>",
  noremap
)
mapset("n", "<leader>ES", vim.diagnostic.show)
mapset("n", "<leader>Es", function()
  vim.diagnostic.show(nil, 0)
end)
mapset("n", "<leader>EH", vim.diagnostic.hide)
mapset("n", "<leader>Eh", function()
  vim.diagnostic.hide(nil, 0)
end)
-- Emacs style keybindings
mapset("i", "<A-p>", "<C-p>", noremap_silent)
mapset("i", "<A-n>", "<C-n>", noremap_silent)
mapset("i", "<C-p>", "<Up>", noremap_silent)
mapset("i", "<C-n>", "<Down>", noremap_silent)
mapset("i", "<A-b>", "<S-Left>", noremap_silent)
mapset("i", "<A-f>", "<S-Right>", noremap_silent)
mapset("i", "<C-b>", "<Left>", noremap_silent)
mapset("i", "<C-f>", "<Right>", noremap_silent)
mapset({ "i", "c" }, "<C-y>", "<C-r>+", noremap_silent)
mapset("i", "<C-x><C-a>", "<C-a>", noremap_silent)
mapset("i", "<C-a>", "<Home>", noremap_silent)
mapset("i", "<C-e>", "<End>", noremap_silent)
mapset("i", "<C-d>", "<Del>", noremap_silent)
mapset("i", "<A-d>", "<C-o>dw", noremap_silent)
-- mapset('i', '<A-v>', '<PageUp>', noremap_silent)
-- mapset('i', '<C-v>', '<PageDown>', noremap_silent)
mapset("i", "<C-k>", "<C-o>D", noremap_silent)
-- Both <BS> and <C-BS> sends ^? on terminals
-- <C-H> equals <C-BS> on st
-- mapset('i', '<C-H>', '<Left><C-o>dvb', noremap_silent)
mapset("i", "<A-BS>", "<Left><C-o>dvb", noremap_silent)
-- <C-u> already exists
mapset("c", "<Esc>", "<C-e><C-u><Esc>")
mapset("c", "<A-p>", "<C-p>")
mapset("c", "<A-n>", "<C-n>")
mapset("c", "<A-b>", "<C-f>b<C-c>")
mapset("c", "<A-f>", "<C-f>e<C-c><Right>")
mapset("c", "<C-b>", "<Left>")
mapset("c", "<C-f>", function()
  -- 'getcmdpos()>strlen(getcmdline())?&cedit:"\\<Lt>Right>"'
  if vim.fn.getcmdpos() > vim.fn.getcmdline():len() then
    return "<C-f>"
  else
    return "<Right>"
  end
end, noremap_expr)
mapset("c", "<C-x><C-a>", "<C-a>")
mapset("c", "<C-a>", "<Home>")
-- <C-e> already exists
-- mapset('c', '<C-e>', '<End>', noremap_silent)
mapset("c", "<C-d>", function()
  -- 'getcmdpos()>strlen(getcmdline())?"\\<Lt>C-D>":"\\<Lt>Del>"'
  if vim.fn.getcmdpos() > vim.fn.getcmdline():len() then
    return "<C-d>"
  else
    return "<Del>"
  end
end, noremap_expr)
mapset("c", "<A-d>", "<C-f>dw<C-c>")
mapset("c", "<C-k>", "<C-f>D<C-c><Right>")
mapset("c", "<A-BS>", function()
  if vim.fn.getcmdpos() > vim.fn.getcmdline():len() then
    return "<C-f>dvb<C-c><Right>"
  else
    return "<C-f>db<C-c>"
  end
end, noremap_expr)

return {
  defaults = { lazy = true },
  install = { colorscheme = { "tokyonight" } },
  performance = {
    cache = {
      enabled = true,
    },
    rtp = {
      reset = true,
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
}
