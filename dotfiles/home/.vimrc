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


" Set the color scheme.
colorscheme molokai

" Disable compatibility with vi which can cause unexpected issues.
set nocompatible

" GENERAL OPTIONS ---------------------------------------------------------------- {{{

" Set the commands to save in history (default is 20).
" Increased for better command history tracking.
set history=1000

" Do not save backup files (keeps directory clean).
set nobackup

" Set cursor shape
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" Do not let cursor scroll below or above N number of lines when scrolling.
" Helps maintain context while reading/editing.
set scrolloff=10

" }}}

" UI ---------------------------------------------------------------- {{{

set termguicolors

" Add line numbers to the file.
set number

" Relative line numbers - helpful when editing code.
set relativenumber

" Highlight cursor line underneath the cursor horizontally.
" Improves focus and visibility of current line.
set cursorline

" Show partial command you type in the last line of the screen.
" Useful for remembering long commands.
set showcmd

" Show the mode you are on (Normal, Insert, Visual, etc.) on the last line.
" Helps quickly understand your current state.
set showmode

" Do not wrap lines. Allow long lines to extend to the edge.
" Better for code editing; you can manually split when needed.
set nowrap

" ---- Filetype detection ----

" Enable filetype detection. Vim will automatically detect file types.
filetype on

" Enable plugins and load plugins for the detected file type.
filetype plugin on

" Load an indent file for the detected file type.
filetype indent on

" Turn syntax highlighting on.
syntax on

" Indentation settings (BASE - apply to all files)
" Set shift width to 2 spaces for most languages.
set shiftwidth=2

" Set tab width to 2 columns (matches shiftwidth).
set tabstop=2

" Use space characters instead of tabs.
set expandtab

" ---- Search & Navigation ----

" While searching through a file, incrementally highlight matching characters as you type.
set incsearch

" Search wraps around to the top of the file when reaching the bottom.
set wrapscan

" Ignore capital letters during search.
set ignorecase

" Override the ignorecase option if searching for capital letters.
" This allows you to search specifically for capital letters (case-sensitive search).
set smartcase

" Show matching words during a search.
set showmatch

" Use highlighting when doing a search.
set hlsearch

" ---- Wildmenu (File completion) ----

" Enable auto completion menu after pressing TAB.
set wildmenu

" Make wildmenu behave like Bash completion.
set wildmode=list:longest

" There are certain files that we would never want to edit with Vim.
" Wildmenu will ignore files with these extensions.
set wildignore+=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

" Add macOS-specific files to ignore.
set wildignore+=*.DS_Store,*.aiff,*.mp3,*.wav,*.mov,*.mp4,*.avi,*.mkv,*.zip,*.rar,*.dmg

" ---- Splits ----

" New splits at the bottom and right.
set splitbelow
set splitright

" }}}

" PLUGINS ---------------------------------------------------------------- {{{

" Vim-Plug plugin manager
call plug#begin('~/.vim/plugged')

  " NERDTree: File explorer
  " Tree-based file explorer that works like a file manager.
  Plug 'preservim/nerdtree'

  " vim-highlightedyank: Highlights last yanked text
  " Shows where you last copied text, helpful for quick pasting.
  Plug 'machakann/vim-highlightedyank'

  " fzf: Fuzzy finder
  " Fuzzy search for files and text within your project.
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'

  " V language syntax-highlighting
  " Auto-Indent and syntactic folding
  Plug 'cheap-glitch/vim-v'

  " Surround
  Plug 'tpope/vim-surround'

  " Repeat
  Plug 'tpope/vim-repeat'

  "Paste with indentation
  Plug 'sickill/vim-pasta'

  " Indent guides
  Plug 'nathanaelkane/vim-indent-guides'

  " Git
  Plug 'airblade/vim-gitgutter'

  " Quick Toggle and Navigation
  Plug 'tpope/vim-unimpaired'

  " which-key
  Plug 'liuchengxu/vim-which-key'

call plug#end()

" }}}

" MAPPINGS --------------------------------------------------------------- {{{

let mapleader = " "
let maplocalleader = "\\"

" Leader key mappings for common commands
" Quick save
nnoremap <leader>s :w<CR>
" Quick reload current file
nnoremap <leader>r :source %<CR>
" Toggle line numbers
nnoremap <leader>ln :set number!<CR>
" Toggle relative line numbers
nnoremap <leader>rn :set relativenumber!<CR>
" Toggle cursorline
nnoremap <leader>cl :set cursorline!<CR>
" Toggle cursorcolumn
nnoremap <leader>cc :set cursorcolumn!<CR>
" Toggle spell check
nnoremap <leader>sp :set spell!<CR>

" Type jj to exit insert mode quickly.
" Common vim practice - escape with jj instead of escaping the key.
inoremap jj <Esc>

" Move to next closing delimiter: ', ", `, >, ), ], }
nnoremap <silent> jl /['"`>\)\]\}]<CR>:nohlsearch<CR>
inoremap <silent> jl <C-o>h<C-o>/['"`>\)\]\}]<CR><C-o>:nohlsearch<CR><C-o>a<Space><BS>

" Move to previous opening delimiter: ', ", `, <, (, {, [
nnoremap <silent> jh ?['"`<\(\{\[]<CR>:nohlsearch<CR>
inoremap <silent> jh <C-o>?['"`<\(\{\[]<CR><C-o>:nohlsearch<CR><C-o>h

" Press the space bar twice to type the : character in command mode.
" Quick access to commands when you need to type them.
nnoremap <space><space> :

" Pressing the letter o will open a new line below the current one.
" Exit insert mode after creating a new line above or below.
" Prevents accidental mode switching.
nnoremap o o<esc>
nnoremap O O<esc>

" Center the cursor vertically when moving to the next word during a search.
" Keeps cursor in the middle of the screen for better readability.
nnoremap n nzz
nnoremap N Nzz

" Yank from cursor to the end of line.
" Quick way to copy the rest of the line.
nnoremap Y y$

" Map the F5 key to run Python script inside Vim.
" Chain of commands:
" 1. :w saves the file
" 2. :!clear clears the terminal
" 3. :!python3 % executes the current file with Python
nnoremap <f5> :w <CR>:!clear <CR>:!python3 % <CR>

" Navigate split windows with hjkl keys.
" Makes window navigation more intuitive.
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" Resize split windows using arrow keys.
" CTRL+UP/DOWN/LEFT/RIGHT to resize windows.
noremap <c-up> <c-w>+
noremap <c-down> <c-w>-
noremap <c-left> <c-w>>
noremap <c-right> <c-w><

" Have nerdtree ignore certain files and directories.
" Keep your file tree clean by hiding unnecessary files.
let NERDTreeIgnore=['\.git$', '\.jpg$', '\.mp4$', '\.ogg$', '\.iso$', '\.pdf$', '\.pyc$', '\.odt$', '\.png$', '\.gif$', '\.db$']

" NERDTree enhanced mappings
nnoremap <leader>e :NERDTreeToggle<CR>

" FZF (fuzzy finder) integration
" Requires fzf.vim plugin
" Navigate files with fuzzy search
nnoremap <leader>ff :Files<CR>
" Navigate buffers with fuzzy search
nnoremap <leader>fb :Buffers<CR>
" Navigate commands with fuzzy search
nnoremap <leader>fc :Commands<CR>
" Select colorscheme
nnoremap <leader>uc :Colors<CR>
" Search Pattern
nnoremap <leader>fp :Rg<CR>
" Navigate Windows
nnoremap <leader>fw :Windows<CR>
" Search opened files
nnoremap <leader>fo :History<CR>
" Search command history
nnoremap <leader>fC :History:<CR>
" Search history
nnoremap <leader>fs :History/<CR>

" Which-key
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>

" }}}

" VIMSCRIPT -------------------------------------------------------------- {{{

" Python: Auto-configure Python file indentation.
autocmd FileType python setlocal shiftwidth=4 tabstop=4

" Enable the marker method of folding for Vim files.
" Useful for organizing large Vim scripts with fold markers.
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END

" HTML: Set indentation to 2 spaces.
autocmd Filetype html setlocal tabstop=2 shiftwidth=2 expandtab

" Undo support across sessions (requires Vim 7.3+)
" This allows you to undo changes to a file even after saving it.
" Creates undo history that persists across restarts.
if version >= 703
    set undodir=~/.vim/backup
    set undofile
    set undoreload=10000
endif

" Display cursorline only in active window.
" Display cursorcolumn only in Insert mode
" When you switch windows, turn off cursor highlighting in the inactive window.
" This reduces visual clutter when managing multiple splits.
augroup cursor_off
    autocmd!
    autocmd WinLeave * set nocursorline nocursorcolumn
    autocmd WinEnter * set cursorline
    autocmd InsertEnter * set cursorcolumn
    autocmd InsertLeave * set nocursorcolumn
augroup END

" If GUI version of Vim is running, set these options.
if has('gui_running')

    " Set the background tone.
    set background=dark

    " Set the color scheme.
    colorscheme molokai

    " Set a custom font you have installed on your computer.
    " Syntax: <font_name> <weight> <size>
    " Adjust based on your installed fonts and preference.
    set guifont=VictorMono\ Nerd\ Font\ Mono\ Regular\ 14

    " Display more of the file by default.
    " Hide the toolbar.
    set guioptions-=T

    " Hide the right-side scroll bar.
    set guioptions-=r

    " Hide the menu bar.
    set guioptions-=m

    " Hide the bottom scroll bar.
    set guioptions-=b

    " Map the F4 key to toggle the menu, toolbar, and scroll bar.
    nnoremap <F4> :if &guioptions=~#'mTr'<Bar>
        \set guioptions-=mTr<Bar>
        \else<Bar>
        \set guioptions+=mTr<Bar>
        \endif<CR>

endif

" Automatically maintain a consistent quickfix window height across window switches
function MaximizeAndResizeQuickfix(quickfixHeight)
  set lazyredraw
  set ei=WinEnter
  wincmd _
  if (getbufvar(winbufnr(winnr()), "&buftype") == "quickfix")
    wincmd p
    resize
    wincmd p
    exe "resize " . a:quickfixHeight
  endif
  set ei-=WinEnter
  set nolazyredraw
endfunction

au WinEnter * call MaximizeAndResizeQuickfix(8)

" }}}

" STATUS LINE ------------------------------------------------------------ {{{

" Clear status line when vimrc is reloaded.
set statusline=

" Status line with essential information.
" Left side: file name, modified flag, file type, read-only flag
set statusline+=%F\ %M\ %Y\ %R

" Middle divider: format/encoding
set statusline+=%=[%{&fileformat}-%{&fileencoding}]%=

" Right side: ascii, hex, row, col, percent
set statusline+=\ ascii:\ %b\ hex:\ 0x%B\ row:\ %l\ col:\ %c\ percent:\ %p%%

" Show the status on the second to last line.
set laststatus=2

" }}}

" USEFUL ADDITIONAL CONFIGURATIONS --------------------------------------- {{{

" Enable system clipboard for pasting
" (Disables xclip/xsel integration if you have it set up elsewhere)
set clipboard=

" }}}
