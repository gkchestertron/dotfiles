" let vim know it's not using system .vimrc
set nocompatible
" set path for .vim folder
set rtp=$VIMRUNTIME,/home/dobby/woodshop/dotfiles/.vim,/home/dobby/woodshop/dotfiles/.vim/bundle/snipmate/after
" basic setup - plugins, color scheme
execute pathogen#infect()
colorscheme desert

let g:rainbow_active = 1

" commands
command Nerd :NERDTree
command Json :%!python -m json.tool
command -nargs=1 MS :mksession ~/vimsessions/<args>.vim 
command -nargs=1 SS :mksession! ~/vimsessions/<args>.vim 
command -nargs=1 LS :source ~/vimsessions/<args>.vim | highlight ConsoleLog ctermbg=8 ctermfg=yellow | highlight OverLength ctermbg=17
command LL :source ~/vimsessions/last.vim | highlight ConsoleLog ctermbg=8 ctermfg=yellow | highlight OverLength ctermbg=17
command -nargs=1 Find :execute 'grep -r <args> --exclude-dir="node_modules" --exclude-dir="dist" --exclude-dir="bower_components" --exclude-dir="tmp" --exclude-dir="coverage" --exclude-dir="tests" --exclude-dir="mirage" --exclude="DEVELOPMENT-SCENARIOS.md" --exclude="CHANGELOG.md" --exclude="CHANGELOG.md" ./*' | copen
command -nargs=1 Findd :execute 'grep -r <args> --exclude-dir="node_modules" --exclude-dir="dist" --exclude-dir="bower_components" --exclude-dir="tmp" --exclude-dir="coverage" --exclude-dir="mirage" --exclude="DEVELOPMENT-SCENARIOS.md" --exclude="CHANGELOG.md" --exclude="CHANGELOG.md" ./*' | copen

" set options and env vars
set shellcmdflag=-ic
set smartindent
set cindent
set ai
set ic
set aw
set nu
set incsearch
set encoding=utf-8
set fileencoding=utf-8
setglobal fileencoding=utf-8
set backspace=indent,eol,start
syntax on
filetype indent plugin on
set runtimepath^=~/.vim/bundle/ctrlp.vim
set foldmethod=syntax
set foldlevel=10

" for react-scripts watching
set backupcopy=yes

" special highlighting for console logs and overlength
highlight ConsoleLog ctermbg=8 ctermfg=yellow
let c = matchadd('ConsoleLog', 'console\.log')
highlight OverLength ctermbg=17
let o = matchadd('OverLength', '\%81v.\+')

" not totally sure what this was for
nnoremap <silent> <Leader>l ml:execute 'match Search /\%'.line('.').'l/'<CR>
highlight Search ctermbg=8 ctermfg=yellow

" auto commands
autocmd BufWinEnter * let c = matchadd('ConsoleLog', 'console\.log') | let o = matchadd('OverLength', '\%81v.\+')
autocmd VimLeavePre * :mksession! ~/vimsessions/last.vim
autocmd BufWinEnter * :highlight SignColumn ctermbg=black
autocmd BufWinEnter * :set ts=2 | set sw=2 | set expandtab | set softtabstop=2
autocmd BufWinEnter * :set nocursorline
autocmd BufWinEnter *.md :set syntax=markdown | set wrap | set linebreak | highlight clear OverLength
autocmd BufWinEnter *.ejs :set syntax=html
autocmd BufWinEnter *.py :set ts=4 | set sw=4 | set expandtab | set softtabstop=4
autocmd BufWinEnter *.go :set tabstop=2 softtabstop=2 shiftwidth=2 noexpandtab
autocmd BufWinEnter *.snippets :set noexpandtab
autocmd BufWinEnter *.graphql :set binary | set noeol

" key mappings
noremap ; :
nmap - :res<CR>:vertical res<CR>$
nmap Y y$
set pastetoggle=<F1>
nnoremap <F2> :set nonumber!<CR>
nnoremap <F3> :RltvNmbr<CR>
nnoremap <F4> :RltvNmbr!<CR>
nnoremap <F5> :AutoComplPopDisable<CR>
nnoremap <F6> :AutoComplPopEnable<CR>
nnoremap <C-l> :10winc><CR>
nnoremap <C-h> :10winc<<CR>
nnoremap <C-k> :10winc+<CR>
nnoremap <C-j> :10winc-<CR>
vnoremap + :Tab/=<CR>
vnoremap : :Tab/:<CR>
nmap <Left> <<
nmap <Right> >>
vmap <Left> <gv
vmap <Right> >gv
" nmap <Up> [e
" nmap <Down> ]e
vmap <Up> [egv
vmap <Down> ]egv

" eslint
let g:syntastic_javascript_checkers=['eslint']
let g:javascript_plugin_jsdoc = 1

" handle mousing
if has("mouse")
    set mouse=a
endif
