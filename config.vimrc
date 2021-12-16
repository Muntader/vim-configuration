""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""" ANKI TECH """""""""""""""""""""""
""""""""""""""" Vim Confinguration """""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""" Default Config """"""""""""""""""""""
filetype plugin indent on

"" Encoding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
set ttyfast

"" Fix backspace indent
set backspace=indent,eol,start

"" Tabs. May be overridden by autocmd rules
set tabstop=4
set softtabstop=0
set shiftwidth=4
set expandtab

"" Map leader to ,
let mapleader=','

"" Enable hidden buffers
set hidden

"" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

set fileformats=unix,dos,mac

if exists('$SHELL')
    set shell=$SHELL
else
    set shell=/bin/sh
endif

" session management
let g:session_directory = "~/.vim/session"
let g:session_autoload = "no"
let g:session_autosave = "no"
let g:session_command_aliases = 1

"*****************************************************************************
"" Visual Settings
"*****************************************************************************
syntax on
set ruler
set number

let no_buffers_menu=1


set mousemodel=popup
set t_Co=256
set guioptions=egmrti
set gfn=Monospace\ 10

  let g:CSApprox_loaded = 1

  " IndentLine
  let g:indentLine_enabled = 1
  let g:indentLine_concealcursor = 0
  let g:indentLine_char = '┆'
  let g:indentLine_faster = 1


"" Disable the blinking cursor.
set gcr=a:blinkon0

set scrolloff=3


"" Status bar
set laststatus=2

"" Use modeline overrides
set modeline
set modelines=10

set title
set titleold="Terminal"
set titlestring=%F
set cursorline 
set statusline=%F%m%r%h%w%=(%{&ff}/%Y)\ (line\ %l\/%L,\ col\ %c)\

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv

if exists("*fugitive#statusline")
  set statusline+=%{fugitive#statusline()}
endif

" vim-airline
let g:airline_theme = 'powerlineish'
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tagbar#enabled = 1
let g:airline_skip_empty_sections = 1


""""""""""""""""""""""" Plugin """"""""""""""""""""""""""""" 
call plug#begin()
Plug 'sheerun/vim-polyglot'

Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
" FZF
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" Use release branch (recommend)
Plug 'neoclide/coc.nvim', {'branch': 'release'}
"" Emmet vim 
Plug 'mattn/emmet-vim'
"" One dark pro
Plug 'joshdick/onedark.vim'
"" Vim one theme 
Plug 'rakr/vim-one'

"" Github intgration 
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'junegunn/gv.vim'
"" Auto pairs - auto close tag
Plug 'tpope/vim-commentary'

"" Airline
Plug 'vim-airline/vim-airline'
Plug 'Yggdroot/indentLine'

call plug#end()
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""" FZF """""""""""""""""""""""""""""" 
fun! s:fzf_root()
let path = finddir(".git", expand("%:p:h").";")
        return fnamemodify(substitute(path, ".git", "", ""), ":p:h")
endfun

command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, {'options': ['--layout=reverse', '--preview', 'cat {}']}, <bang>0)

function! s:fzf_statusline()
  " Override statusline as you like
  highlight fzf1 ctermfg=161 ctermbg=251
  highlight fzf2 ctermfg=23 ctermbg=251
  highlight fzf3 ctermfg=237 ctermbg=251
  setlocal statusline=%#fzf1#\ >\ %#fzf2#fz%#fzf3#f
endfunction



let g:fzf_tags_command = 'ctags -R'
let g:fzf_preview_window = ''
let g:fzf_buffers_jump = 0
nmap <silent> <leader>m :History<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" 

"""""""""""""""""""""""" Keybind """""""""""""""""""""""""" 
"""" FZF
nmap <C-p> :Files<CR>
noremap <Leader>b :Buffers<CR>
"" Switching windows
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <C-h> <C-w>h

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" 

"""""""""""""""""""""""" Emmet """""""""""""""""""""""""""" 
function! s:expand_html_tab()

  " try to determine if we're within quotes or tags.
  " if so, assume we're in an emmet fill area.
  let line = getline('.')
  if col('.') < len(line)
    let line = matchstr(line, '[">][^<"]*\%'.col('.').'c[^>"]*[<"]')

    if len(line) >= 2
      return "\<Plug>(emmet-move-next)"
    endif
  endif

  " go to next item in a popup menu.
  if pumvisible()
    return "\<C-n>"
  endif

  " expand anything emmet thinks is expandable.
  " I'm not sure control ever reaches below this block.
  if emmet#isExpandable()
    return "\<Plug>(emmet-expand-abbr)"
  endif

  " return a regular tab character
  return "\<tab>"
endfunction

autocmd FileType html,css,blade.php,blade imap <buffer><expr><tab> <sid>expand_html_tab()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" 

""""""""""""""""""""""" NerdTree """""""""""""""""""""""""" 
map <C-n> :NERDTreeToggle<CR>
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" 

"""""""""""""""""""""""" Coc """""""""""""""""""""""""""""" 
" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

autocmd BufNewFile,BufRead *.blade.php set filetype=blade

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" 
""""""""""""""""""""""" Theme """"""""""""""""""""""""""""" 
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
      set termguicolors
  endif
syntax on
set background=dark
let g:one_allow_italics = 1 " I love italic for comments
let g:airline_theme='one'
colorscheme one


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""" Git Sign """""""""""""""""""""""""" 
" Change these if you want
let g:signify_sign_add               = '+'
let g:signify_sign_delete            = '_'
let g:signify_sign_delete_first_line = '‾'
let g:signify_sign_change            = '~'

" I find the numbers disctracting
let g:signify_sign_show_count = 0
let g:signify_sign_show_text = 1


" Jump though hunks
nmap <leader>gj <plug>(signify-next-hunk)
nmap <leader>gk <plug>(signify-prev-hunk)
nmap <leader>gJ 9999<leader>gJ
nmap <leader>gK 9999<leader>gk
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

