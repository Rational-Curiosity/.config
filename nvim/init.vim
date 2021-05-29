" Indent

set shiftwidth=4
set tabstop=4
set softtabstop=2
set expandtab

" Folding

set foldmethod=indent
set foldnestmax=10
set nofoldenable
set foldlevel=2

" Key

let mapleader = "\<Space>"
nnoremap <silent> <A-y> :registers "0123456789abcdefghijklmnopqrstuvwxyz*+.<CR>
tnoremap <Esc> <C-\><C-n>

" Encoding

set encoding=utf-8
set fileencoding=utf-8
language messages en_US.UTF-8

" Appearance

autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE
autocmd ColorScheme * highlight LineNr ctermfg=grey guifg=grey
colorscheme industry
set list listchars=tab:↦˙,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨
set cursorline

" Line numbers

set number relativenumber

augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

" Programs

set grepprg=rg\ --vimgrep\ --smart-case\ --follow
set clipboard+=unnamedplus

" Directories

" set autochdir " When this option is on some plugins may not work.
"autocmd BufEnter * silent! lcd %:p:h

if !empty(glob("~/Prog/gigas/TAGS"))
    set tags+=~/Prog/gigas/TAGS
endif

" Searching

set ignorecase
set smartcase

" Undo

set undodir=~/.vim/undo
if !isdirectory(&undodir)
    call mkdir(&undodir, "p")
endif
set undofile

" PLUGINS

call plug#begin(stdpath('data') . '/plugged')

Plug 'easymotion/vim-easymotion'
Plug 'mbbill/undotree'
Plug 'airblade/vim-rooter'
Plug 'liuchengxu/vim-which-key'
Plug 'osyo-manga/vim-anzu'
Plug 'jreybert/vimagit'
Plug 'jmcantrell/vim-virtualenv'
Plug 'vim-airline/vim-airline'
Plug 'junegunn/vim-peekaboo'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'tpope/vim-surround'
Plug 't9md/vim-choosewin'
Plug 'ludovicchabant/vim-gutentags'
Plug 'justinmk/vim-sneak'
" Build the extra binary if cargo exists on your system.
Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary' }

call plug#end()

" VIM-SNEAK PLUGIN

nmap f <Plug>Sneak_s
nmap F <Plug>Sneak_S
nmap t <Plug>Sneak_t
nmap T <Plug>Sneak_T

" VIM-AIRLINE PLUGIN

"let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline_section_b = "%{expand('%:p:h:t')}"

" CHOOSEWIN PLUGIN

nmap <A-o> <Plug>(choosewin)

" EASYMOTION PLUGIN

" <Leader>f{char} to move to {char}
map  <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)

" s{char}{char} to move to {char}{char}
nmap <Leader>F <Plug>(easymotion-overwin-f2)

" Move to line
map <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)

" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)

" WHICHKEY PLUGIN

hi link WhichKeyFloating Background
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>

"g {{
"    nnoremap <silent><nowait> [G] :<c-u>WhichKey 'g'<cr>
"    nmap g [G]
"    let g:which_key_g= {}
"    let g:which_key_g['<C-G>'] = ['call feedkeys("g\<c-g>", "n")', 'show cursor info']
"    nnoremap g<c-g> g<c-g>
"    let g:which_key_g['&'] = ['call feedkeys("g&", "n")', 'repeat last ":s" on all lines']
"    nnoremap g& g&
"
"    let g:which_key_g["'"] = ['call feedkeys("g' . "'" . '", "n")', 'jump to mark']
"    nnoremap g' g'
"    let g:which_key_g['`'] = ['call feedkeys("g' . '`' . '", "n")', 'jump to mark']
"    nnoremap g` g`
"
"    let g:which_key_g['+'] = ['call feedkeys("g+", "n")', 'newer text state']
"    nnoremap g+ g+
"    let g:which_key_g['-'] = ['call feedkeys("g-", "n")', 'older text state']
"    nnoremap g- g-
"    let g:which_key_g[','] = ['call feedkeys("g,", "n")', 'newer position in change list']
"    nnoremap g, g,
"    let g:which_key_g[';'] = ['call feedkeys("g;", "n")', 'older position in change list']
"    nnoremap g; g;
"    let g:which_key_g['@'] = ['call feedkeys("g@", "n")', 'call operatorfunc']
"    nnoremap g@ g@
"
"    let g:which_key_g['#'] = ['call feedkeys("\<Plug>(incsearch-nohl-g#)")', 'search under cursor backward']
"    let g:which_key_g['*'] = ['call feedkeys("\<Plug>(incsearch-nohl-g*)")', 'search under cursor forward']
"    let g:which_key_g['/'] = ['call feedkeys("\<Plug>(incsearch-stay)")', 'stay incsearch']
"    let g:which_key_g['$'] = ['call feedkeys("g$", "n")', 'go to rightmost character']
"    nnoremap g$ g$
"    let g:which_key_g['<End>'] = ['call feedkeys("g$", "n")', 'go to rightmost character']
"    nnoremap g<End> g<End>
"    let g:which_key_g['0'] = ['call feedkeys("g0", "n")', 'go to leftmost character']
"    nnoremap g0 g0
"    let g:which_key_g['<Home>'] = ['call feedkeys("g0", "n")', 'go to leftmost character']
"    nnoremap g<Home> g<Home>
"    let g:which_key_g['e'] = ['call feedkeys("ge", "n")', 'go to end of previous word']
"    nnoremap ge ge
"    let g:which_key_g['<'] = ['call feedkeys("g<", "n")', 'last page of previous command output']
"    nnoremap g< g<
"    let g:which_key_g['f'] = ['call feedkeys("gf", "n")', 'edit file under cursor']
"    nnoremap gf gf
"    let g:which_key_g['F'] = ['call feedkeys("gF", "n")', 'edit file under cursor(jump to line after name)']
"    nnoremap gF gF
"    let g:which_key_g['j'] = ['call feedkeys("gj", "n")', 'move cursor down screen line']
"    nnoremap gj gj
"    let g:which_key_g['k'] = ['call feedkeys("gk", "n")', 'move cursor up screen line']
"    nnoremap gk gk
"    let g:which_key_g['u'] = ['call feedkeys("gu", "n")', 'make motion text lowercase']
"    nnoremap gu gu
"    let g:which_key_g['E'] = ['call feedkeys("gE", "n")', 'end of previous word']
"    nnoremap gE gE
"    let g:which_key_g['U'] = ['call feedkeys("gU", "n")', 'make motion text uppercase']
"    nnoremap gU gU
"    let g:which_key_g['H'] = ['call feedkeys("gH", "n")', 'select line mode']
"    nnoremap gH gH
"    let g:which_key_g['h'] = ['call feedkeys("gh", "n")', 'select mode']
"    nnoremap gh gh
"    let g:which_key_g['I'] = ['call feedkeys("gI", "n")', 'insert text in column 1']
"    nnoremap gI gI
"    let g:which_key_g['i'] = ['call feedkeys("gi", "n")', "insert text after '^ mark"]
"    nnoremap gi gi
"    let g:which_key_g['J'] = ['call feedkeys("gJ", "n")', 'join lines without space']
"    nnoremap gJ gJ
"    let g:which_key_g['N'] = ['call feedkeys("gN", "n")', 'visually select previous match']
"    nnoremap gN gN
"    let g:which_key_g['n'] = ['call feedkeys("gn", "n")', 'visually select next match']
"    nnoremap gn gn
"    let g:which_key_g['Q'] = ['call feedkeys("gQ", "n")', 'switch to Ex mode']
"    nnoremap gQ gQ
"    let g:which_key_g['q'] = ['call feedkeys("gq", "n")', 'format Nmove text']
"    nnoremap gq gq
"    let g:which_key_g['R'] = ['call feedkeys("gR", "n")', 'enter VREPLACE mode']
"    nnoremap gR gR
"    let g:which_key_g['T'] = ['call feedkeys("gT", "n")', 'previous tag page']
"    nnoremap gT gT
"    let g:which_key_g['t'] = ['call feedkeys("gt", "n")', 'next tag page']
"    nnoremap gt gt
"    let g:which_key_g[']'] = ['call feedkeys("g]", "n")', 'tselect cursor tag']
"    nnoremap g] g]
"    let g:which_key_g['^'] = ['call feedkeys("g^", "n")', 'go to leftmost no-white character']
"    nnoremap g^ g^
"    let g:which_key_g['_'] = ['call feedkeys("g_", "n")', 'go to last char']
"    nnoremap g_ g_
"    let g:which_key_g['~'] = ['call feedkeys("g~", "n")', 'swap case for Nmove text']
"    nnoremap g~ g~
"    let g:which_key_g['a'] = ['call feedkeys("ga", "n")', 'print ascii value of cursor character']
"    nnoremap ga ga
"    let g:which_key_g['g'] = ['call feedkeys("gg", "n")', 'go to line N']
"    nnoremap gg gg
"    let g:which_key_g['m'] = ['call feedkeys("gm", "n")', 'go to middle of screenline']
"    nnoremap gm gm
"    let g:which_key_g['o'] = ['call feedkeys("go", "n")', 'goto byte N in the buffer']
"    nnoremap go go
"    let g:which_key_g.s = ['call feedkeys("gs", "n")', 'sleep N seconds']
"    nnoremap gs gs
"    let g:which_key_g['v'] = ['call feedkeys("gv", "n")', 'reselect the previous Visual area']
"    nnoremap gv gv
"    let g:which_key_g['<C-]>'] = ['call feedkeys("g<c-]>", "n")', 'jump to tag under cursor']
"    nnoremap g<c-]> g<c-]>
"call which_key#register('g', "g:which_key_g")
"}}
"y{{
"    nnoremap <silent><nowait> [Y] :<c-u>WhichKey "y"<CR>
"    nmap y [Y]
"    let g:which_key_y = {}
"    let g:which_key_y['y'] = ['call feedkeys("yy", "n")', 'yank the current line']
"    nnoremap yy yy
"    let g:which_key_y['$'] = ['call feedkeys("y$", "n")', 'yank to the end of the current line']
"    nnoremap y$ y$
"call which_key#register('y', "g:which_key_y")
"}}
"CTRL-W{{
"    nnoremap <silent><nowait> [CTRL-W] :<c-u>WhichKey "ctrl-w"<CR>
"    nmap <C-w> [CTRL-W]
"    let g:which_key_ctrl_w = {}
"    let g:which_key_ctrl_w['+'] = ['call feedkeys("<C-w>+", "n")', 'increase current window height N lines']
"    nnoremap <C-w>+ <C-w>+
"    let g:which_key_ctrl_w['-'] = ['call feedkeys("<C-w>-", "n")', 'increase current window height N lines']
"    nnoremap <C-w>- <C-w>-
"    let g:which_key_ctrl_w['<'] = ['call feedkeys("<C-w><", "n")', 'increase current window height N lines']
"    nnoremap <C-w>< <C-w><
"    let g:which_key_ctrl_w['='] = ['call feedkeys("<C-w>=", "n")', 'increase current window height N lines']
"    nnoremap <C-w>= <C-w>=
"    let g:which_key_ctrl_w['>'] = ['call feedkeys("<C-w>>", "n")', 'increase current window height N lines']
"    nnoremap <C-w>> <C-w>>
"    let g:which_key_ctrl_w['H'] = ['call feedkeys("<C-w>H", "n")', 'increase current window height N lines']
"    nnoremap <C-w>H <C-w>H
"    let g:which_key_ctrl_w['J'] = ['call feedkeys("<C-w>J", "n")', 'increase current window height N lines']
"    nnoremap <C-w>J <C-w>J
"    let g:which_key_ctrl_w['K'] = ['call feedkeys("<C-w>K", "n")', 'increase current window height N lines']
"    nnoremap <C-w>K <C-w>K
"    let g:which_key_ctrl_w['L'] = ['call feedkeys("<C-w>L", "n")', 'increase current window height N lines']
"    nnoremap <C-w>L <C-w>L
"    let g:which_key_ctrl_w['P'] = ['call feedkeys("<C-w>P", "n")', 'increase current window height N lines']
"    nnoremap <C-w>P <C-w>P
"    let g:which_key_ctrl_w['R'] = ['call feedkeys("<C-w>R", "n")', 'increase current window height N lines']
"    nnoremap <C-w>R <C-w>R
"    let g:which_key_ctrl_w['S'] = ['call feedkeys("<C-w>S", "n")', 'increase current window height N lines']
"    nnoremap <C-w>S <C-w>S
"    let g:which_key_ctrl_w['T'] = ['call feedkeys("<C-w>T", "n")', 'increase current window height N lines']
"    nnoremap <C-w>T <C-w>T
"    let g:which_key_ctrl_w['W'] = ['call feedkeys("<C-w>W", "n")', 'increase current window height N lines']
"    nnoremap <C-w>W <C-w>W
"    let g:which_key_ctrl_w[']'] = ['call feedkeys("<C-w>]", "n")', 'increase current window height N lines']
"    nnoremap <C-w>] <C-w>]
"    let g:which_key_ctrl_w['^'] = ['call feedkeys("<C-w>^", "n")', 'increase current window height N lines']
"    nnoremap <C-w>^ <C-w>^
"    let g:which_key_ctrl_w['_'] = ['call feedkeys("<C-w>_", "n")', 'increase current window height N lines']
"    nnoremap <C-w>_ <C-w>_
"    let g:which_key_ctrl_w['b'] = ['call feedkeys("<C-w>b", "n")', 'increase current window height N lines']
"    nnoremap <C-w>b <C-w>b
"call which_key#register('ctrl-w', "g:which_key_ctrl_w")
"}}
"z{{
"    nnoremap <silent><nowait> [Z] :<c-u>WhichKey "z"<CR>
"    nmap z [Z]
"    let g:which_key_z = {}
"    let g:which_key_z['<CR>'] = ['call feedkeys("z\<CR>", "n")', 'cursor line to top']
"    nnoremap z<CR> z<CR>
"    let g:which_key_z['+'] = ['call feedkeys("z+", "n")', 'cursor to screen top line N']
"    nnoremap z+ z+
"    let g:which_key_z['-'] = ['call feedkeys("z-", "n")', 'cursor to screen bottom line N']
"    nnoremap z- z-
"    let g:which_key_z['^'] = ['call feedkeys("z^", "n")', 'cursor to screen bottom line N']
"    nnoremap z^ z^
"    let g:which_key_z['.'] = ['call feedkeys("z.", "n")', 'cursor line to center']
"    nnoremap z. z.
"    let g:which_key_z['='] = ['call feedkeys("z=", "n")', 'spelling suggestions']
"    nnoremap z= z=
"    let g:which_key_z['A'] = ['call feedkeys("zA", "n")', 'toggle folds recursively']
"    nnoremap zA zA
"    let g:which_key_z['C'] = ['call feedkeys("zC", "n")', 'close folds recursively']
"    nnoremap zC zC
"    let g:which_key_z['D'] = ['call feedkeys("zD", "n")', 'delete folds recursively']
"    nnoremap zD zD
"    let g:which_key_z['E'] = ['call feedkeys("zE", "n")', 'eliminate all folds']
"    nnoremap zE zE
"    let g:which_key_z['F'] = ['call feedkeys("zF", "n")', 'create a fold for N lines']
"    nnoremap zF zF
"    let g:which_key_z['G'] = ['call feedkeys("zG", "n")', 'mark good spelled(update internal-wordlist)']
"    nnoremap zG zG
"    let g:which_key_z['H'] = ['call feedkeys("zH", "n")', 'scroll half a screenwidth to the right']
"    nnoremap zH zH
"    let g:which_key_z['L'] = ['call feedkeys("zL", "n")', 'scroll half a screenwidth to the left']
"    nnoremap zL zL
"    let g:which_key_z['M'] = ['call feedkeys("zM", "n")', 'set `foldlevel` to zero']
"    nnoremap zM zM
"    let g:which_key_z['N'] = ['call feedkeys("zN", "n")', 'set `foldenable`']
"    nnoremap zN zN
"    let g:which_key_z['O'] = ['call feedkeys("zO", "n")', 'open folds recursively']
"    nnoremap zO zO
"    let g:which_key_z['R'] = ['call feedkeys("zR", "n")', 'set `foldlevel` to deepest fold']
"    nnoremap zR zR
"    let g:which_key_z['W'] = ['call feedkeys("zW", "n")', 'mark wrong spelled']
"    nnoremap zW zW
"    let g:which_key_z['X'] = ['call feedkeys("zX", "n")', 're-apply `foldleve`']
"    nnoremap zX zX
"    let g:which_key_z['a'] = ['call feedkeys("za", "n")', 'toggle a fold']
"    nnoremap za za
"    let g:which_key_z['b'] = ['call feedkeys("zb", "n")', 'redraw, cursor line at bottom']
"    nnoremap zb zb
"    let g:which_key_z['c'] = ['call feedkeys("zc", "n")', 'close a fold']
"    nnoremap zc zc
"    let g:which_key_z['d'] = ['call feedkeys("zd", "n")', 'delete a fold']
"    nnoremap zd zd
"    let g:which_key_z['e'] = ['call feedkeys("ze", "n")', 'right scroll horizontally to cursor position']
"    nnoremap ze ze
"    let g:which_key_z['f'] = ['call feedkeys("zf", "n")', 'create a fold for motion']
"    nnoremap zf zf
"    let g:which_key_z['g'] = ['call feedkeys("zg", "n")', 'mark good spelled']
"    nnoremap zg zg
"    let g:which_key_z['h'] = ['call feedkeys("zh", "n")', 'scroll screen N characters to right']
"    nnoremap zh zh
"    let g:which_key_z['<Left>'] = ['call feedkeys("zh", "n")', 'scroll screen N characters to right']
"    nnoremap z<Left> zh
"    let g:which_key_z['i'] = ['call feedkeys("zi", "n")', 'toggle foldenable']
"    nnoremap zi zi
"    let g:which_key_z['j'] = ['call feedkeys("zj", "n")', 'move to start of next fold']
"    nnoremap zj zj
"    let g:which_key_z['J'] = ['call feedkeys("zjzx", "n")', 'move to and open next fold']
"    nnoremap zJ zjzx
"    let g:which_key_z['k'] = ['call feedkeys("zk", "n")', 'move to end of previous fold']
"    nnoremap zk zk
"    let g:which_key_z['K'] = ['call feedkeys("zkzx", "n")', 'move to and open previous fold']
"    nnoremap zK zkzx
"    let g:which_key_z['l'] = ['call feedkeys("zl", "n")', 'scroll screen N characters to left']
"    nnoremap zl zl
"    let g:which_key_z['<Right>'] = ['call feedkeys("zl", "n")', 'scroll screen N characters to left']
"    nnoremap z<Right> zl
"    let g:which_key_z['m'] = ['call feedkeys("zm", "n")', 'subtract one from `foldlevel`']
"    nnoremap zm zm
"    let g:which_key_z['n'] = ['call feedkeys("zn", "n")', 'reset `foldenable`']
"    nnoremap zn zn
"    let g:which_key_z['o'] = ['call feedkeys("zo", "n")', 'open fold']
"    nnoremap zo zo
"    let g:which_key_z['r'] = ['call feedkeys("zr", "n")', 'add one to `foldlevel`']
"    nnoremap zr zr
"    let g:which_key_z.s = ['call feedkeys("zs", "n")', 'left scroll horizontally to cursor position']
"    nnoremap zs zs
"    let g:which_key_z['t'] = ['call feedkeys("zt", "n")', 'cursor line at top of window']
"    nnoremap zt zt
"    let g:which_key_z['v'] = ['call feedkeys("zv", "n")', 'open enough folds to view cursor line']
"    nnoremap zv zv
"    let g:which_key_z['x'] = ['call feedkeys("zx", "n")', 're-apply foldlevel and do "zV"']
"    nnoremap zx zx
"    " smart scroll
"    let g:which_key_z['z'] = ['call feedkeys("zz", "n")', 'smart scroll']
"    nnoremap zz zz
"call which_key#register('z', "g:which_key_z")
"}}


" EMACS KEY BINDINGS

" normal mode
nnoremap <A-f> w
nnoremap <C-<> <C-v>
nnoremap <A-v> <C-b>
nnoremap <C-v> <C-f>
nnoremap <C-b> <Left>
nnoremap <C-f> <Right>
nnoremap <C-e> $
nnoremap <C-a> 0
nnoremap <A-m> ^
nnoremap <C-d> x
inoremap <A-v> <PageUp>
inoremap <C-v> <PageDown>

" insert mode
inoremap <A-p> <C-p>
inoremap <A-n> <C-n>
inoremap <C-p> <Up>
inoremap <C-n> <Down>
inoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-d> <Del>
inoremap <A-v> <PageUp>
inoremap <C-v> <PageDown>
"imap <C-k> <C-r>=<SID>kill_line()<CR>

" command line mode
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <A-b> <S-Left>
cnoremap <A-f> <S-Right>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-d> <Del>

"cnoremap <C-k> <C-f>D<C-c><C-c>:<Up>
cnoremap <A-BS> <C-w>

" command-T window
let g:CommandTCursorLeftMap  = ['<Left>',  '<C-b>']
let g:CommandTCursorRightMap = ['<Right>', '<C-f>']
let g:CommandTDeleteMap      = ['<Del>',   '<C-d>']

function! s:home()
  let start_col = col('.')
  normal! ^
  if col('.') == start_col
    normal! 0
  endif
  return ''
endfunction

function! s:kill_line()
  let [text_before_cursor, text_after_cursor] = s:split_line_text_at_cursor()
  if len(text_after_cursor) == 0
    normal! J
  else
    call setline(line('.'), text_before_cursor)
  endif
  return ''
endfunction

function! s:split_line_text_at_cursor()
  let line_text = getline(line('.'))
  let text_after_cursor  = line_text[col('.')-1 :]
  let text_before_cursor = (col('.') > 1) ? line_text[: col('.')-2] : ''
  return [text_before_cursor, text_after_cursor]
endfunction
