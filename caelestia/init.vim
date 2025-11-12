" ════════════════════════════════════════════════════════════════════════════════════════════════
"  Last Modified: 11/07/2025 - RCF
"  simple .vimrc Configuration
" ════════════════════════════════════════════════════════════════════════════════════════════════

" ────────────────────────────────────────────────────────────────────────────────────────────────
"  General Settings
" ────────────────────────────────────────────────────────────────────────────────────────────────

set nocompatible                    " Disables old vi compatibility
filetype plugin indent on           " Enables filetype detection, plugins, and indent
syntax enable                       " Enables syntax highlighting
set encoding=utf-8                  " Uses UTF-8 encoding
set number                          " Shows line numbers
set relativenumber                  " Shows relative line numbers
set showcmd                         " Shows last command in status line
set showmode                        " Shows current mode
set linebreak						" Enables word wrapping
set textwidth=0						" Fully disables auto wrapping
set ruler                           " Shows line/column info
set cursorline                      " Highlights current line
set hidden                          " Allows switching buffers without saving
set clipboard=unnamed           	" Uses system clipboard
colorscheme slate 					" Sets default color theme
let mapleader = " "                 " Sets leader key to spacebar
set showtabline=2					" Always shows the tab line at the top
set ttyfast							" Optimizes redraws for better performance, i think
set mouse=							" Completely disables mouse support

" ────────────────────────────────────────────────────────────────────────────────────────────────
"  Indentation & Tabs
" ────────────────────────────────────────────────────────────────────────────────────────────────

set tabstop=4                       " Number of spaces per tab
set shiftwidth=4                    " Indent width
set smartindent                     " Auto-indent new lines
set matchpairs+=<:>                 " Match angle brackets
set autoindent						" Auto matches the indentation of prev line

" ────────────────────────────────────────────────────────────────────────────────────────────────
"  Search Settings
" ────────────────────────────────────────────────────────────────────────────────────────────────

set ignorecase                      " Case-insensitive search
set smartcase                       " Case-sensitive if search has capitals
set hlsearch                        " Highlight search results
set incsearch                       " Incremental search

" ────────────────────────────────────────────────────────────────────────────────────────────────
"  UI Enhancements
" ────────────────────────────────────────────────────────────────────────────────────────────────

set wildmenu                        " Better command-line completion
set lazyredraw                      " Faster scrolling
set scrolloff=12                    " Keep 12 lines visible around cursor

" ────────────────────────────────────────────────────────────────────────────────────────────────
"  Status Line
" ────────────────────────────────────────────────────────────────────────────────────────────────

set laststatus=2                    						" Always show status line
set statusline=%<%f\ [R.C.F]%h%w%r%=%l/%L\ \|\ %p%%\ \|\ %m

"  Split Navigation
" ────────────────────────────────────────────────────────────────────────────────────────────────

nnoremap <C-h> <C-w>h               " Move to left split
nnoremap <C-j> <C-w>j               " Move to split below
nnoremap <C-k> <C-w>k               " Move to split above
nnoremap <C-l> <C-w>l               " Move to right split

" ────────────────────────────────────────────────────────────────
" Horizontal movement wrap
" ────────────────────────────────────────────────────────────────

" Pressing h at start of line goes to the end of the line above
nnoremap <expr> h col('.') == 1 ? 'k$' : 'h'

" Pressing l at end of line goes to the first column of the next line
nnoremap <expr> l col('.') == col('$') - 1 ? 'j0' : 'l'

" Also lets arrows keys do the same
set whichwrap+=<,>

" ────────────────────────────────────────────────────────────────────────────────────────────────
"  Quality of Life
" ────────────────────────────────────────────────────────────────────────────────────────────────

set confirm                         " Ask before quitting unsaved file
set history=1000                    " Command history size
set undofile                        " Persistent undo
set undolevels=5000                " More undo history
set undoreload=5000                " Save more lines for undo on buffer reload
set backupdir=~/.vim/tmp,.          " Backup directory
set directory=~/.vim/tmp,.          " Swap file directory

" ────────────────────────────────────────────────────────────────────────────────────────────────
"  Netrw File Explorer Settings
" ────────────────────────────────────────────────────────────────────────────────────────────────

let g:netrw_banner = 0              " Hide banner
let g:netrw_liststyle = 3           " Tree-style view
let g:netrw_browse_split = 3        " Open files in a new tab 
let g:netrw_altv = 1                " Open splits to the right
let g:netrw_winsize = 25            " Width of netrw window (25%)

" ────────────────────────────────────────────────────────────────────────────────────────────────
"  Autocommands
" ────────────────────────────────────────────────────────────────────────────────────────────────

" Applies relative line numbers to all netrw buffers
augroup netrw_settings
    autocmd!
    autocmd FileType netrw setlocal number relativenumber
augroup END

" Apply relative line numbers to all buffers
augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu | endif
    autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu | set nornu | endif
augroup END

" When vim is started with no file, it opens up netrw in normal mode (full-screen)
augroup netrw_startup
    autocmd!
    autocmd VimEnter * if argc() == 0 | Explore | call feedkeys("\<Esc>") | endif
augroup END

" Prevent auto-commenting on new lines
augroup format_options
    autocmd!
	autocmd BufEnter * setlocal formatoptions-=r | setlocal formatoptions-=o | setlocal formatoptions-=c 
augroup END

" TCL-SPECIFIC SETTINGS
augroup tcl_settings
    autocmd!
    autocmd FileType tcl setlocal commentstring=#\ %s		"Tells vim to treat lines w/ # as comments
    autocmd FileType tcl setlocal foldmethod=syntax			"syntax-based folding
    autocmd FileType tcl setlocal foldlevelstart=99			"opens all folds by default
augroup END

" ────────────────────────────────────────────────────────────────────────────────────────────────
"  Netrw Toggle Functions
" ────────────────────────────────────────────────────────────────────────────────────────────────

" Check if netrw buffer exists in current tab
function! NetrwIsOpen()
	"loops through a range of open windows
    for i in range(1, winnr('$'))
		"checks each window (i) and sees if it is a netrw wintype
        if getwinvar(i, '&filetype') == 'netrw'
			"if it is a netrw window, return it
            return i
        endif
    endfor
	"otherwise return 0
    return 0
endfunction

" Toggle netrw in vertical split
function! ToggleNetrwVSplit()
	"puts the window value to a new variable
    let netrw_win = NetrwIsOpen()
	"if var is nonzero, thus win exists, goto if, otherwise goto else
    if netrw_win
		"if current window is netrw wintype, close it
        if winnr() == netrw_win
            close
        else
			"if current window isn't netrw win, navigate to it, then close it
            execute netrw_win . 'wincmd w'
            close
        endif
    else
		"if no netrw window found, open netrw in Vertical split
        Vexplore
    endif
endfunction

" Toggle netrw in current window code logic commented above
function! ToggleNetrwNormal()
    let netrw_win = NetrwIsOpen()
    if netrw_win
        if winnr() == netrw_win
            if winnr('$') == 1
                bprevious
            else
                close
            endif
        else
            execute netrw_win . 'wincmd w'
        endif
    else
        Explore
    endif
endfunction

" ────────────────────────────────────────────────────────────────────────────────────────────────
"  Key Bindings
" ────────────────────────────────────────────────────────────────────────────────────────────────

" NETRW KEYBINDINGS (Shortcuts to open up the tree navigator)
nnoremap <leader>e :call ToggleNetrwVSplit()<CR>            " Toggle netrw in vertical split
nnoremap <leader>E :call ToggleNetrwNormal()<CR>            " Toggle netrw in current window

" VISUAL BLOCK MODE (Ctrl+V remapped for paste)
nnoremap <leader>q <C-v>                                    " Visual block mode with Spacebar+Q

"CLIPBOARD OPERATIONS (if vim doesn't have clipboard, comment out the next 5 lines
vnoremap <C-c> "+y                                          " Copy to system clipboard in visual mode
vnoremap <C-x> "+d                                          " Cut to system clipboard in visual mode
nnoremap <C-v> "+p                                          " Paste from system clipboard in normal mode
inoremap <C-v> <C-r>+                                       " Paste from system clipboard in insert mode
vnoremap <C-v> "+p                                          " Paste from system clipboard in visual mode

" BETTER MOVEMENT 
nnoremap H ^												" Moves to beginning of the line
nnoremap L $												" Moves to the end of hte line
nnoremap J }												" Moves 1 paragraph down (whitespace)
nnoremap K {												" Moves 1 paragrah up (whitespace)
nnoremap <leader>f :call search(input("Search: "), 'W')<CR>

" Original Vim screen/navigation behavior on g-prefixed keys
nnoremap gH H
nnoremap gL L
nnoremap gJ J
nnoremap gK K

" LINE MANIPULATION
nnoremap <leader>j :m .+1<CR>==         					" Move line down with Space+j
nnoremap <leader>k :m .-2<CR>==         					" Move line up with Space+k
vnoremap <leader>j :m '>+1<CR>gv=gv     					" Move selection down
vnoremap <leader>k :m '<-2<CR>gv=gv     					" Move selection up
nnoremap <leader>o :put _<CR>								" Adds line below in normal mode
nnoremap <leader>O :put! _<CR>								" Adds line above in normal mode

" BUFFER MANAGEMENT
nnoremap <leader>n :bnext<CR>                               " Next buffer
nnoremap <leader>p :bprevious<CR>                           " Previous buffer
nnoremap <leader>d :bdelete<CR>                             " Delete buffer
nnoremap <leader>ls :ls<CR>:b<Space>                        " List and switch buffers

" SEARCH ENHANCEMENTS
nnoremap <leader>s :nohlsearch<CR>                          " Clear search highlighting

" QUICK COMMENTING FOR TCL (# comment style)
nnoremap <leader>c I# <Esc>                                 " Comment line
nnoremap <leader>u ^2x                                      " Uncomment line
vnoremap <leader>c :s/^/# /<CR>:nohlsearch<CR>              " Comment selection
vnoremap <leader>u :s/^# //<CR>:nohlsearch<CR>              " Uncomment selection

" SEARCH AND REPLACE (replaces the word under the cursor)
nnoremap <leader>* :%s/\<<C-r><C-w>\>//g<Left><Left>

" SPLIT AND TAB MANAGEMENT
nnoremap <leader>x <C-w>c                                   " Close current split
nnoremap <leader>X <C-w>o                                   " Close all other splits (keep current)
nnoremap <leader>T <C-w>T                                   " Move split to new tab
nnoremap <leader>tn :tabnew<CR>                             " New tab
nnoremap <leader>tc :tabclose<CR>                           " Close tab
nnoremap <leader>1 1gt                                      " Go to tab 1
nnoremap <leader>2 2gt                                      " Go to tab 2
nnoremap <leader>3 3gt                                      " Go to tab 3
nnoremap <leader>4 4gt                                      " Go to tab 4
nnoremap <leader>5 5gt                                      " Go to tab 5
nnoremap <leader>v :vsplit<CR><C-w>w                        " Vertical split
nnoremap <leader>h :split<CR><C-w>w                         " Horizontal split

" ════════════════════════════════════════════════════════════════════════════════════════════════
"  End of Configuration
" ════════════════════════════════════════════════════════════════════════════════════════════════

" SIDE NOTES:
" setxkbmap -option caps:escape (add this to .bashrc to make CAPSLOCK == <ESC>
