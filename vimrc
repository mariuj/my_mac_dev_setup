"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
"               ██╗   ██╗██╗███╗   ███╗██████╗  ██████╗
"               ██║   ██║██║████╗ ████║██╔══██╗██╔════╝
"               ██║   ██║██║██╔████╔██║██████╔╝██║
"               ╚██╗ ██╔╝██║██║╚██╔╝██║██╔══██╗██║
"                ╚████╔╝ ██║██║ ╚═╝ ██║██║  ██║╚██████╗
"                 ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader = "\<Space>"
set number relativenumber
set nu rnu
set nowrap

" Options:
set nocompatible
filetype on
filetype plugin on
filetype indent on
syntax on
set encoding=utf8
set clipboard=unnamed " Enables the clipboard between Vim/Neovim and other applications.
set completeopt=noinsert,menuone,noselect " Modifies the auto-complete menu to behave more like an IDE.
set hidden " Hide unused buffers
set mouse=a " Allow to use the mouse in the editor
set title " Show file title
set wildmenu " Show a more advance menu
set cc=120 " Show at 80 column a border for good code style
set backspace=indent,eol,start " Remove backspace restrictions in insert mode
set showmatch
set timeoutlen=100

" indenting:
set autoindent
set smartindent
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

" Orientation:
nnoremap <PageUp> <C-u>
nnoremap <PageDown> <C-d>
nnoremap <S-Up> 10k
nnoremap <S-Down> 10j


""""""""""""""""""""
" vim-plug:
""""""""""""""""""""
" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin()
" flinters
Plug 'dense-analysis/ale'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'jaxbot/semantic-highlight.vim'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'rafamadriz/friendly-snippets'
Plug 'airblade/vim-gitgutter'
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'itchyny/lightline.vim'
Plug 'catppuccin/vim', { 'as': 'catppuccin' }
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }
Plug 'liuchengxu/vim-which-key'
call plug#end()


""""""""""""""""""""
" Theme related
""""""""""""""""""""
set termguicolors
set noshowmode
let g:lightline = {'colorscheme': 'catppuccin_frappe'}
set laststatus=2

" colors
highlight PmenuSel guibg=darkgray guifg=black
highlight Pmenu guibg=gray  guifg=white


""""""""""""""""""""
" Key mappings
""""""""""""""""""""
" Toggle Markdown Preview
nmap <Leader>m <Plug>MarkdownPreviewToggle

" Toggle Semantic Highlight
nmap <Leader>s :SemanticHighlightToggle<CR>

" DIAGNOSTICS mappings
nmap <Leader>d<Up> <Plug>(ale_previous_wrap)
nmap <Leader>d<Down> <Plug>(ale_next_wrap)
nmap <Leader>d<Right> :ALEDetail<CR>

" NERDTree mappings
nmap <Leader>n<Left> :tabprevious<CR>
nmap <Leader>n<Right> :tabnext<CR>
nmap <Leader>n<Up> :NERDTreeToggle<CR>
nmap <Leader>n<Down> <C-w>w

""""""""""""""""""""
" Vim-which-key
""""""""""""""""""""
call which_key#register('<Space>', "g:which_key_map")
nnoremap <silent> <leader> :silent <c-u> :silent WhichKey '<Space>'<CR>
let g:which_key_sep = '→'
let g:which_key_map = {}
let g:which_key_timeout = 100

let g:which_key_map['m'] = [ '<Plug>MarkdownPreviewToggle',  'Toggle MD preview' ]
let g:which_key_map['s'] = [ ':SemanticHighlightToggle', 'Toggle semantic highlight' ]


let g:which_key_map.g = {
            \ 'name' : '+GOTO' ,
            \ 'd' : [ ' gd', 'Go to definition' ],
            \ 'h' : [ ' K', 'Go to hover' ]
            \}

let g:which_key_map.d = {
            \ 'name' : '+DIAGNOSTICS' ,
            \ '<Up>' : [ '<Plug>(ale_previous_wrap)', 'Previous diagnostic' ],
            \ '<Down>' : [ '<Plug>(ale_next_wrap)', 'Next diagnostic' ],
            \ '<Right>' : [ ':ALEDetail', 'Show detailed diagnostic' ],
            \}

let g:which_key_map.n = {
            \ 'name' : '+NERD',
            \ '<Left>' : [ ':tabprevious', 'Previous tab' ],
            \ '<Right>' : [ ':tabnext', 'Next tab' ],
            \ '<Up>' : [ ':NERDTreeToggle', 'Toggle tree' ],
            \ '<Down>' : [ '<C-w>w', 'Switch tree/tab' ],
            \}


""""""""""""""""""""
" ale Setup
""""""""""""""""""""
let g:ale_linters = {
\   'python': ['ruff', 'mypy'],
\}

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'python': ['ruff','isort'],
\}

let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1
let g:ale_fix_on_save = 1

let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'


""""""""""""""""""""
" vim-lsp Setup
""""""""""""""""""""
if executable('ruff-langserver')
    autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'ruff',
        \ 'cmd': ['ruff-langserver', '--stdio'],
        \ 'allowlist': ['python'],
        \ })
endif

" Function to open in tab instead of buffer
function! OpenLspTab(command)
    let current_pos = getpos('.')
    let current_buf = bufnr('%')

    tab split
    execute a:command
    sleep 100m

    let new_pos = getpos('.')
    let new_buf = bufnr('%')

    if new_pos == current_pos && new_buf == current_buf
        tabprevious
        tabclose
    endif
endfunction

" LSP setup
function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif

    nnoremap <buffer> <Leader>gd :call OpenLspTab('LspDefinition')<CR>
    nmap <buffer> <Leader>K <plug>(lsp-hover)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
endfunction

augroup lsp_install
    au!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

let g:lsp_diagnostics_enabled = 0 " This disables vim-lsp diagnostics.


""""""""""""""""""""
" vim-vsnip Setup
""""""""""""""""""""
" Expand
imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'

" Expand or jump
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

" Jump forward or backward
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'

" Select or cut text to use as $TM_SELECTED_TEXT in the next snippet.
" See https://github.com/hrsh7th/vim-vsnip/pull/50
nmap        s   <Plug>(vsnip-select-text)
xmap        s   <Plug>(vsnip-select-text)
nmap        S   <Plug>(vsnip-cut-text)
xmap        S   <Plug>(vsnip-cut-text)


""""""""""""""""""""
" Semantic Highligh
""""""""""""""""""""
autocmd BufEnter * :SemanticHighlight
