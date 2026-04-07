"disable llama plugin by default
"au FileType * call llama#disable()

let g:NERDTreeNodeDelimiter = "\u00a0"

" vx
noremap <C-X>b <Cmd>call vx#commands#OpenOrClosePromptBuffer()<CR>
noremap <C-X>x <Cmd>call vx#commands#Stop()<CR>
noremap <C-X>X <Cmd>call vx#commands#Execute()<CR>
noremap <C-X>y <Cmd>call vx#commands#Copy(0)<CR>
noremap <C-X>Y <Cmd>call vx#commands#Copy(1)<CR>
noremap <C-X>p <Cmd>call vx#commands#Paste()<CR>
inoremap <C-X>p <Cmd>call vx#commands#Paste()<CR>

" chat mode
inoremap <C-X>c <Cmd>call vx#commands#ProcessBuffer({'config': {'tool_choice': 'none'}})<CR>
" chat mode with research tools only
inoremap <C-X>r <Cmd>call vx#commands#ProcessBuffer({'config': {'tools': ["get_folder_structure", "get_file_summary", "retrieve_code_snippet", "search_code_snippets"], 'tool_choice': 'auto'}})<CR>
" chat mode with all tools
inoremap <C-X>x <Cmd>call vx#commands#ProcessBuffer({'config': {'tool_choice': 'auto'}})<CR>
" delegator mode
"inoremap <C-X>d <Cmd>call vx#commands#ProcessBuffer('administrator', 'auto')<CR>

" navigation
noremap <C-X>k <Cmd>call vx#commands#JumpToMessage(0)<CR>
noremap <C-X>j <Cmd>call vx#commands#JumpToMessage(1)<CR>


"global
colorscheme desert
set nu rnu
set incsearch
set ignorecase
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set splitright
set smartindent
let g:markdown_fenced_languages = ['html', 'python', 'ruby', 'vim', 'javascript', 'go', 'css', 'json', 'diff', 'sql', 'dart', 'sh', 'bash']
" fixes background coloring in transparent iterm2
set t_ut=

" python
au FileType python setlocal expandtab
au FileType python setlocal tabstop=2
au FileType python setlocal shiftwidth=2
au FileType python setlocal softtabstop=2

" golang
au FileType go setlocal expandtab
au FileType go setlocal tabstop=2
au FileType go setlocal shiftwidth=2
au FileType go setlocal softtabstop=2

" markdown
au FileType markdown setlocal expandtab
au FileType markdown setlocal tabstop=2
au FileType markdown setlocal shiftwidth=2
au FileType markdown setlocal softtabstop=2

" use mouse
set mouse=a

" Enable folding
set foldenable

" Use syntax-based folding for code
set foldmethod=syntax

" Set fold level (0-9)
set foldlevel=99
set foldcolumn=2

" Enable folding in insert mode
set foldopen+=insert

" javascript folding 
let g:javaScript_fold = 1

" Save current folds to a file
function! MakeFolds()
    " Clear existing folds
    setlocal foldlevel=0
    setlocal foldmethod=manual
    
    " Create folds for function definitions
    let line = 1
    let foldstart = -1
    
    while line <= line('$')
        let linecontent = getline(line)
        
        " Check for function start
        if linecontent =~ '^\s*function\|^\s*func'
            let foldstart = line
        " Check for function end
        elseif linecontent =~ '^\s*endfunction\|^\s*endfunc'
            if foldstart != -1
                execute 'normal! ' . foldstart . 'Gzf' . line . 'G'
                let foldstart = -1
            endif
        endif
        
        let line = line + 1
    endwhile
    
    " Set fold method to manual for the current buffer
    setlocal foldmethod=manual
    setlocal foldlevel=99
endfunction

" handle manual folding
autocmd FileType vim call MakeFolds()
