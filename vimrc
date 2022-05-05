" vimrc

" Define usefull paths
let $DESKTOP = expand("$HOME/Desktop")
let $CODING = expand("$HOME/Coding")

" Basics
set nocompatible
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,latin1
set fileformats=unix,dos

" Trim whitespaces on save
autocmd BufWritePre * :%s/\s\+$//e

" Os
if has('win32unix') || has('win32')
    let $VIMFILES = expand("$HOME/vimfiles")
    set rtp+=$VIMFILES
elseif has('win32')
    let $VIMFILES = expand("$HOME/vimfiles")
else
    let $VIMFILES = expand("$HOME/.vim")
endif

"Gui
if has('gui_running')
    set guioptions-=m
    set guioptions-=T
    set guioptions-=r
    set guioptions-=R
    set guioptions-=l
    set guioptions-=L

    if has('unix')
        set guifont=DejaVu\ Sans\ Mono\ 11
    else
        set guifont=Consolas:h11
        " Maximize
        au GUIEnter * simalt ~x
    endif
endif

" Clipboard
if has('clipboard')
    set clipboard^=unnamed,unnamedplus
endif

" Remap leader
let mapleader = "\<Space>"

" Before-load plugin configs
let g:ale_disable_lsp = 1

" Vim Plug
call plug#begin($VIMFILES.'/plugged')
    " Visual
    Plug 'gruvbox-community/gruvbox'
    Plug 'itchyny/lightline.vim'
    Plug 'yggdroot/indentline'

    " Navigation
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'scrooloose/nerdtree'
    Plug 'mbbill/undotree'

    " Motions
    Plug 'easymotion/vim-easymotion'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-commentary'
    Plug 'mg979/vim-visual-multi'
    Plug 'dhruvasagar/vim-table-mode'

    " Git
    Plug 'tpope/vim-fugitive'
    Plug 'airblade/vim-gitgutter'
    Plug 'xuyuanp/nerdtree-git-plugin'
    Plug 'itchyny/vim-gitbranch'

    " Ale
    Plug 'dense-analysis/ale'
    Plug 'maximbaz/lightline-ale'

    " Coc
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    " Plug 'pappasam/coc-jedi', {'do': 'yarn install --frozen-lockfile && yarn build', 'branch': 'main'}
    " Plug 'fannheyward/coc-pyright', {'do': 'yarn install --frozen-lockfile && yarn build', 'branch': 'main'}

    " Python
    " Plug 'vim-python/python-syntax'
    Plug 'gilsonk/vim-python-string-sql'
    Plug 'heavenshell/vim-pydocstring', {'do': 'make install', 'for': 'python'}
    Plug 'Vimjas/vim-python-pep8-indent', {'for': 'python'}

    " SQL
    Plug 'gilsonk/vim-sql'
    " Plug 'vim-scripts/dbext.vim', {'for': 'sql'}
    " Plug 'tpope/vim-dadbod', {'for': 'sql'}

    " UNIX only
    if has('unix')
        Plug 'christoomey/vim-tmux-navigator'
        Plug 'baskerville/vim-sxhkdrc'
        Plug 'smancill/conky-syntax.vim'
    endif
call plug#end()

" Python
let g:python_highlight_all = 1

" NERDtree
map <Leader>N :NERDTreeToggle<CR>

" Open NERDtree on startup if no file is specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter *
    \ if argc() == 0 && !exists("s:std_in") |
        \ NERDTree |
    \ endif

" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter *
    \ if bufname('#') =~ 'NERD_tree_\d\+'
        \ && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
        \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" |
        \ execute 'buffer'.buf |
    \ endif

" Wildignore
let NERDTreeRespectWildIgnore=1
" Python
set wildignore+=*/__pycache__/*
set wildignore+=*.py[cod]
set wildignore+=*/build/*
set wildignore+=*/dist/*
" Git
set wildignore+=**/.git/*
" Documents
set wildignore+=*.pdf
set wildignore+=*.doc*
set wildignore+=*.dot*
set wildignore+=*.pps*
set wildignore+=*.ppt*
set wildignore+=*.xls*
set wildignore+=*.xlt*
" Pictures
set wildignore+=*.bmp
set wildignore+=*.jpg
set wildignore+=*.jpeg
set wildignore+=*.png
set wildignore+=*.svg
" Archives
set wildignore+=*.7z
set wildignore+=*.rar
set wildignore+=*.zip
set wildignore+=*.tar.*
set wildignore+=*.bz
set wildignore+=*.gz
" Other
set wildignore+=*.exe

" CTRLP
nnoremap <Leader>p :CtrlP<CR>
nnoremap <Leader>b :CtrlPBuffer<CR>

" Buffers
nnoremap <Leader><Tab> <C-^>

" Lightline, with
" * ALE
" * gitbranch
set laststatus=2
let g:lightline = {}
let g:lightline.component_expand = {
    \ 'linter_checking': 'lightline#ale#checking',
    \ 'linter_infos': 'lightline#ale#infos',
    \ 'linter_warnings': 'lightline#ale#warnings',
    \ 'linter_errors': 'lightline#ale#errors',
    \ 'linter_ok': 'lightline#ale#ok',
\ }
let g:lightline.component_function = {
    \ 'gitbranch': 'gitbranch#name'
\ }
let g:lightline.component_type = {
    \ 'linter_checking': 'right',
    \ 'linter_infos': 'right',
    \ 'linter_warnings': 'warning',
    \ 'linter_errors': 'error',
    \ 'linter_ok': 'right',
\ }
let g:lightline.active = {
    \ 'right': [ [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok' ],
    \            [ 'lineinfo' ],
    \            [ 'percent' ],
    \            [ 'fileformat', 'fileencoding', 'filetype'] ],
    \ 'left': [ [ 'mode', 'paste' ],
    \           [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
\ }

" ALE Fixer
let g:ale_fixers = {
    \ '*': ['remove_trailing_lines', 'trim_whitespace'],
    \ 'python': ['black'],
\ }
let g:ale_fix_on_save = 0

" indentLine
let g:indentLine_char = '¦'

" EasyMotion
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_startofline = 0
let g:EasyMotion_smartcase = 1
map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>h <Plug>(easymotion-linebackward)
map <Leader>/ <Plug>(easymotion-sn)
omap <Leader>/ <Plug>(easymotion-tn)
nmap <Leader>s <Plug>(easymotion-s2)
nmap <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>e <Plug>(easymotion-bd-e)
nmap <Leader>a <Plug>(easymotion-jumptoanywhere)

" Undotree
nnoremap <Leader>u :UndotreeToggle<CR>

" Python DocString
let g:pydocstring_formatter = 'google'

" CTRL-A like
nnoremap <Leader><Leader>a ggVG
vnoremap <Leader><Leader>a <Esc>ggVG

" CTRL-C in visual mode
vnoremap <C-c> y

" CTRL-V in insert and command mode
inoremap <C-v> <C-r><C-o>+
cnoremap <C-v> <C-r><C-o>+

" Macros
nnoremap Q @q
vnoremap Q :norm @q<CR>
nnoremap <Leader>Q Q

" Blackhole delete
nnoremap <Leader>c "_c
vnoremap <Leader>c "_c
nnoremap <Leader>d "_d
vnoremap <Leader>d "_d

" Highlight last inserted text
nnoremap gV `[v`]

" Colorscheme
syntax on
set t_Co=256
let g:gruvbox_contrast_dark = 'hard'
set background=dark
colorscheme gruvbox
set colorcolumn=80

" Fix cursors and background in rxvt*
if (&term =~ 'xterm' || &term =~ 'tmux')
    let &t_SI = "\<Esc>[5 q"
    let &t_SR = "\<Esc>[3 q"
    let &t_EI = "\<Esc>[2 q"
    highlight Normal ctermbg=None
endif

" Display
set cursorline
set display+=lastline
set list
set listchars=tab:>.,trail:.,extends:#,nbsp:.
set mouse=a
set noerrorbells
set novisualbell
set number
set ruler
set scrolloff=1
set showcmd
set showmatch
set showmode
set signcolumn=number
set title
set titlestring=%t
set updatetime=300
set wildmenu
set wildmode=full

" History
set history=500

" Buffers
set hidden

" Reload files
set autoread

" Backup
try
    set backupdir=$VIMFILES/backup/
    set backup
catch
    set nobackup
endtry

" Undodir
try
    set undodir=$VIMFILES/undodir/
    set undofile
catch
    set noundofile
endtry

" Search
set hlsearch
set incsearch
set ignorecase
set smartcase
nnoremap <silent> <Leader>n :nohls<CR>

" Relative line number
set norelativenumber
nnoremap <silent> <Leader><Leader>n :set relativenumber!<CR>

" Wrapping
set wrap
set linebreak
set breakindent
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

" Beginning / End lines
noremap H ^
noremap L g_
nnoremap <Leader>H H
nnoremap <Leader>L L

" Lines
noremap J 5j
noremap K 5k
noremap <Leader>J J
noremap <Leader><Leader>K K

" Split lines
nnoremap <Leader>K r<CR>

" Redraw
set lazyredraw

" Splits
set splitbelow
set splitright
nnoremap <C-j> <C-W><C-j>
nnoremap <C-k> <C-W><C-k>
nnoremap <C-l> <C-W><C-l>
nnoremap <C-h> <C-W><C-h>

" Backspace
set backspace=eol,start,indent

" Indent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set shiftround
set autoindent
set smartindent

" Indent with tab
nnoremap <Tab> >>_
nnoremap <S-Tab> <<_
inoremap <S-Tab> <C-D>
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

" Folding
set nofoldenable
set foldmethod=indent
set foldlevel=0
"Toggle fold
noremap <silent> <Leader>z :set foldenable!<CR>

" Spell
set nospell
setlocal spelllang=en
try
    setlocal spelllang+=fr
catch
endtry
noremap <silent> <F12> :set spell!<CR>
inoremap <silent> <F12> <Esc>:set spell!<CR>

" Convert DOS to UNIX
function! DosToUnix()
    :update
    :e ++ff=dos
    :setlocal fileformat=unix
    :w
endfunction

" Convert to UTF
function! IsoToUtf()
    :update
    :e ++enc=latin1
    :setlocal fileencoding=utf-8
    :w
endfunction

