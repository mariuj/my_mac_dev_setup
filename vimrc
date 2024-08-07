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
"" Leader key
let mapleader = "\<Space>"    " Set <Space> as leader key

"" Numbering and Wrapping
set number                   " Show absolute line numbers
set relativenumber           " Show relative line numbers

"" General Options
set nocompatible             " Disable Vi compatibility
set encoding=utf8            " Use UTF-8 encoding
set clipboard=unnamed        " Use the * register for the default yank/paste
set mouse=a                  " Enable mouse support in all modes
set title                    " Set the window title to reflect the file name
set nowrap                   " Don't wrap long lines
set wildmenu                 " Visual autocomplete for command menu
set cc=120                   " Highlight column 120 (useful for code formatting)
set backspace=indent,eol,start " Make backspace key more powerful
set scrolloff=5              " Minimum number of screen lines to keep above and below the cursor
set sidescrolloff=5          " Minimum number of screen columns to keep to the left and right of the cursor

"" Indentation Options
set autoindent               " Carry the indentation from the previous line
set smartindent              " Automatically inserts indentation in some cases
set expandtab                " Use spaces instead of tabs
set tabstop=4                " A tab is 4 spaces
set shiftwidth=4             " Number of spaces for indentation
set softtabstop=4            " Make tab key indents act like 4 spaces

"" Interface Enhancements
set showmatch                " Highlight matching braces
set completeopt=menuone,noinsert,noselect " Better completion experience
set hidden                   " Hide buffers instead of closing them
set timeoutlen=100           " Time in milliseconds to wait for key sequence completion



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
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'rafamadriz/friendly-snippets'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'itchyny/lightline.vim'
Plug 'morhetz/gruvbox'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }
Plug 'liuchengxu/vim-which-key'
Plug 'preservim/vim-indent-guides'
call plug#end()

""""""""""""""""""""
" GUI settings
""""""""""""""""""""
set termguicolors
let g:lightline = {'colorscheme': 'catppuccin_frappe'}
set noshowmode
set laststatus=2
colorscheme gruvbox
set background=dark
let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ }

highlight PmenuSel guibg=#5C4033 guifg=#F5E0DC
highlight Pmenu guibg=#6E4B3A guifg=#F5E0DC
highlight Normal guibg=#3E2C29 guifg=#F5E0DC

""""""""""""""""""""
" Key mappings
""""""""""""""""""""

" Orientation
nnoremap <PageUp> <C-u>
nnoremap <PageDown> <C-d>
nnoremap <S-Up> {
nnoremap <S-Down> }

" Toggle Markdown Preview
nmap <Leader>m <Plug>MarkdownPreviewToggle

" DIAGNOSTICS mappings
nmap <Leader>d<Up> <Plug>(ale_previous_wrap)
nmap <Leader>d<Down> <Plug>(ale_next_wrap)
nmap <Leader>d<Right> :ALEDetail<CR>

" NERDTree mappings
nmap <Leader>n<Left> :tabprevious<CR>
nmap <Leader>n<Right> :tabnext<CR>
nmap <Leader>n<Up> :NERDTreeToggle<CR>
nmap <Leader>n<Down> <C-w>w

" asyncomplete tab completion
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"

" Gitgutter
nnoremap <silent> <Space>Gs :GitGutterStageHunk<CR>
nnoremap <silent> <Space>Gr :GitGutterRevertHunk<CR>
nnoremap <silent> <Space>Gn :GitGutterNextHunk<CR>
nnoremap <silent> <Space>Gp :GitGutterPrevHunk<CR>
nnoremap <silent> <Space>Gu :GitGutterUndoHunk<CR>
nnoremap <silent> <Space>Gq :GitGutterQuickFix<CR>

""""""""""""""""""""
" Vim-which-key
""""""""""""""""""""
call which_key#register('<Space>', "g:which_key_map")
nnoremap <silent> <leader> :silent <c-u> :silent WhichKey '<Space>'<CR>
let g:which_key_sep = '→'
let g:which_key_map = {}
let g:which_key_timeout = 100

let g:which_key_map['m'] = [ '<Plug>MarkdownPreviewToggle',  'Toggle MD preview' ]

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

let g:which_key_map.G = {
    \ 'name' : '+git-gutter',
    \ 's' : ['<cmd>GitGutterStageHunk<CR>', 'Stage Hunk'],
    \ 'r' : ['<cmd>GitGutterRevertHunk<CR>', 'Revert Hunk'],
    \ 'n' : ['<cmd>GitGutterNextHunk<CR>', 'Next Hunk'],
    \ 'p' : ['<cmd>GitGutterPrevHunk<CR>', 'Previous Hunk'],
    \ 'u' : ['<cmd>GitGutterUndoHunk<CR>', 'Undo Hunk'],
    \ 'q' : ['<cmd>GitGutterQuickFix<CR>', 'Quick Fix'],
    \ }


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
if executable('pyright-langserver')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyright-langserver',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'pyright-langserver --stdio']},
        \ 'allowlist': ['python'],
        \ 'workspace_config': {
        \   'python': {
        \     'analysis': {
        \       'useLibraryCodeForTypes': v:true
        \      },
        \   },
        \ }
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

""""""""""""""""""""
" Assorted plugin options
""""""""""""""""""""
let g:indent_guides_enable_on_vim_startup = 1
let g:lsp_diagnostics_enabled = 0

" Automatically refresh git-gutter after exiting insert mode
augroup gitgutter_refresh
  autocmd!
  autocmd InsertLeave * GitGutter
augroup END
