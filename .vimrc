colorscheme desert
noremap ; :
imap <C-v>p <C-k>p*
map <C-h> /\/\*<CR>
command Nerd :NERDTree
command Json :%!python -m json.tool
command -nargs=1 MS :mksession ~/vimsessions/<args>.vim 
command -nargs=1 SS :mksession! ~/vimsessions/<args>.vim 
command -nargs=1 LS :source ~/vimsessions/<args>.vim | highlight ConsoleLog ctermbg=8 ctermfg=yellow | highlight OverLength ctermbg=17
command LL :source ~/vimsessions/last.vim | highlight ConsoleLog ctermbg=8 ctermfg=yellow | highlight OverLength ctermbg=17
set smartindent
set cindent
set ai
set ic
set aw
set nu
" set cursorline
set incsearch
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
autocmd BufWinEnter *.rb :set ts=2 | set sw=2 | set expandtab | set softtabstop=2
autocmd BufWinEnter *.md :set syntax=markdown
autocmd BufWinEnter *.ejs :set syntax=html
autocmd BufWinEnter *\(.rb\)\@<! :set ts=4 | set sw=4 | set expandtab | set softtabstop=4
set pastetoggle=<F1>
nnoremap <F2> :set nonumber!<CR>
nnoremap <F3> :RltvNmbr<CR>
nnoremap <F4> :RltvNmbr!<CR>
nnoremap <F5> :AutoComplPopDisable<CR>
nnoremap <F6> :AutoComplPopEnable<CR>
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
vnoremap + :Tab/=<CR>
vnoremap : :Tab/:<CR>
if has("mouse")
    set mouse=a
endif
nmap Y y$
set encoding=utf-8
set fileencoding=utf-8
setglobal fileencoding=utf-8
set backspace=indent,eol,start
