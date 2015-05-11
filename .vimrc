colorscheme desert
noremap ; :
imap <C-v>p <C-k>p*
map <C-h> /\/\*<CR>
command NJ :NERDTree src/bnb/srcjs/
command NT :NERDTree src/bnb/templates/
command NL :NERDTree src/bnb/less/
command NC :NERDTree src/core/
command NI :NERDTree src/core/identity/
command NA :NERDTree src/core/api/v1/
command ND :NERDTree src/dmva/
command TNJ :tabe | NERDTree src/bnb/srcjs/
command TNT :tabe | NERDTree src/bnb/templates/
command TNL :tabe | NERDTree src/bnb/less/
command TNC :tabe | NERDTree src/core/
command TNI :tabe | NERDTree src/core/identity/
command TNA :tabe | NERDTree src/core/api/v1/
command TC  :tabclose
command Nerd :NERDTree
command -nargs=1 MS :mksession ~/vimsessions/<args>.vim 
command -nargs=1 SS :mksession! ~/vimsessions/<args>.vim 
command -nargs=1 LS :source ~/vimsessions/<args>.vim | highlight ConsoleLog ctermbg=8 ctermfg=yellow | highlight OverLength ctermbg=17
command LL :source ~/vimsessions/last.vim | highlight ConsoleLog ctermbg=8 ctermfg=yellow | highlight OverLength ctermbg=17
set smartindent
set cindent
syntax on
set ai
set ic
set aw
set ts=4
set nu
set sw=4
set expandtab
set softtabstop=4
set incsearch
set cursorline
execute pathogen#infect()
syntax on
filetype indent plugin on
set runtimepath^=~/.vim/bundle/ctrlp.vim
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces
nmap - :res<CR>:vertical res<CR>$
highlight ConsoleLog ctermbg=8 ctermfg=yellow
let c = matchadd('ConsoleLog', 'console\.log')
highlight OverLength ctermbg=17
let o = matchadd('OverLength', '\%81v.\+')
autocmd BufWinEnter * let c = matchadd('ConsoleLog', 'console\.log') | let o = matchadd('OverLength', '\%81v.\+')
autocmd VimLeavePre * :mksession! ~/vimsessions/last.vim
autocmd BufWinEnter * :highlight SignColumn ctermbg=black
set pastetoggle=<F1>
nnoremap <F3> :RltvNmbr<CR>
nnoremap <F4> :RltvNmbr!<CR>
nnoremap <F2> :set nonumber!<CR>
nnoremap <silent> <Leader>l ml:execute 'match Search /\%'.line('.').'l/'<CR>
highlight Search ctermbg=8 ctermfg=yellow
map <Right> <C-w>l
map <Left> <C-w>h
map <Up> <C-w>k
map <Down> <C-w>j
set <S-Down>=[1;2B
map <S-Right> :10winc><CR>
map <S-Left> :10winc<<CR>
map <S-Up> :10winc+<CR>
map <S-Down> :10winc-<CR>
command -nargs=1 Findp :grep -r -i -E --exclude-dir=build --exclude-dir=v2 --exclude-dir=v2debug 'function <args>\|class <args>' --include \*.php *
command -nargs=1 Findj :grep -r -i -E --exclude-dir=build --exclude-dir=v2 --exclude-dir=v2debug 'function <args>\|<args>:\|<args> =' --include \*.js * --exclude navinjection\.js
command -nargs=1 Find :grep -r -i -E --exclude-dir=build --exclude-dir=v2 --exclude-dir=v2debug <args> --include \*.php --include \*.js * --include \*.tpl --exclude navinjection\.js
nmap <C-j> vey:Findj <C-r>"<CR>:copen<CR><C-w><C-p>:vsp<CR><C-o><C-w>l:30winc><CR>z<CR>
nmap <C-k> vey:Findp <C-r>"<CR>:copen<CR><C-w><C-p>:vsp<CR><C-o><C-w>l:30winc><CR>z<CR>
nmap <C-l> vey:Find <C-r>"<CR>:copen<CR>z<CR>
vmap <C-j> y:Findj <C-r>"<CR>:copen<CR><C-w><C-p>:vsp<CR><C-o><C-w>l:30winc><CR>z<CR>
vmap <C-k> y:Findp <C-r>"<CR>:copen<CR><C-w><C-p>:vsp<CR><C-o><C-w>l:30winc><CR>z<CR>
vmap <C-l> y:Find <C-r>"<CR>:copen<CR>z<CR>
vnoremap + =
vnoremap = :Tab/=<CR>
vnoremap : :Tab/:<CR>
if has("mouse")
    set mouse=a
endif
nmap Y y$
set encoding=utf-8
set fileencoding=utf-8
setglobal fileencoding=utf-8
