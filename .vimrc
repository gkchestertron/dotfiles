execute pathogen#infect()
let g:rainbow_active = 1
colorscheme desert
noremap ; :
command Nerd :NERDTree
command Json :%!python -m json.tool
command -nargs=1 MS :mksession ~/vimsessions/<args>.vim 
command -nargs=1 SS :mksession! ~/vimsessions/<args>.vim 
command -nargs=1 LS :source ~/vimsessions/<args>.vim | highlight ConsoleLog ctermbg=8 ctermfg=yellow | highlight OverLength ctermbg=17
command LL :source ~/vimsessions/last.vim | highlight ConsoleLog ctermbg=8 ctermfg=yellow | highlight OverLength ctermbg=17
command -nargs=1 Find :execute 'grep -r <args> --exclude-dir="node_modules" --exclude-dir="dist" --exclude-dir="bower_components" --exclude-dir="tmp" --exclude-dir="coverage" --exclude-dir="tests" --exclude-dir="mirage" --exclude="DEVELOPMENT-SCENARIOS.md" --exclude="CHANGELOG.md" --exclude="CHANGELOG.md" ./*' | copen
command -nargs=1 Findd :execute 'grep -r <args> --exclude-dir="node_modules" --exclude-dir="dist" --exclude-dir="bower_components" --exclude-dir="tmp" --exclude-dir="coverage" --exclude-dir="mirage" --exclude="DEVELOPMENT-SCENARIOS.md" --exclude="CHANGELOG.md" --exclude="CHANGELOG.md" ./*' | copen
set smartindent
set cindent
set ai
set ic
set aw
set nu
set incsearch
syntax on
filetype indent plugin on
set runtimepath^=~/.vim/bundle/ctrlp.vim
nmap - :res<CR>:vertical res<CR>$
highlight ConsoleLog ctermbg=8 ctermfg=yellow
let c = matchadd('ConsoleLog', 'console\.log')
highlight OverLength ctermbg=17
let o = matchadd('OverLength', '\%81v.\+')
autocmd BufWinEnter * let c = matchadd('ConsoleLog', 'console\.log') | let o = matchadd('OverLength', '\%81v.\+')
autocmd VimLeavePre * :mksession! ~/vimsessions/last.vim
autocmd BufWinEnter * :highlight SignColumn ctermbg=black
autocmd BufWinEnter * :set ts=2 | set sw=2 | set expandtab | set softtabstop=2
autocmd BufWinEnter * :set nocursorline
autocmd BufWinEnter *.md :set syntax=markdown | set wrap | set linebreak | highlight clear OverLength | set spell
autocmd BufWinEnter *.ejs :set syntax=html
autocmd BufWinEnter *.py :set ts=4 | set sw=4 | set expandtab | set softtabstop=4
autocmd BufWinEnter *.snippets :set noexpandtab
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

" eslint - only run fix if not in tests - it rewrites skipped tests
let g:syntastic_javascript_checkers=['eslint']
autocmd BufWinEnter *.js if expand('%') !~ "test" | let g:syntastic_javascript_eslint_args = ['--fix'] | endif
let g:javascript_plugin_jsdoc = 1
