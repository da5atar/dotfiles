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
" Colorscheme
" Use molokai for GUI version, terminal will use default or separate config
colorscheme molokai
set termguicolors

" Disable compatibility with vi which can cause unexpected issues.
set nocompatible

" GENERAL OPTIONS ---------------------------------------------------------------- {{{

" Set the commands to save in history (default is 20).
" Increased for better command history tracking.
set history=1000

" Do not save backup files (keeps directory clean).
set nobackup

" Do not let cursor scroll below or above N number of lines when scrolling.
" Helps maintain context while reading/editing.
set scrolloff=10

" }}}

" UI ---------------------------------------------------------------- {{{

" Add line numbers to the file.
set number

" Relative line numbers - helpful when editing code.
set relativenumber

" Highlight cursor line underneath the cursor horizontally.
" Improves focus and visibility of current line.
set cursorline

" Highlight cursor column underneath the cursor vertically.
" Helps track cursor position across windows.
set cursorcolumn

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

  " ALE: Asynchronous Lint Engine
  " Provides real-time syntax checking and linting for your code.
  " Alternative: Consider coc.nvim or vim-lsp for better LSP support.
  Plug 'dense-analysis/ale'

  " NERDTree: File explorer
  " Tree-based file explorer that works like a file manager.
  " Alternative: vim-pane or neogit for more modern alternatives.
  Plug 'preservim/nerdtree'

  " vim-highlightedyank: Highlights last yanked text
  " Shows where you last copied text, helpful for quick pasting.
  Plug 'machakann/vim-highlightedyank'

  " fzf: Fuzzy finder
  " Fuzzy search for files and text within your project.
  Plug 'junegunn/fzf'

call plug#end()

" }}}

" MAPPINGS --------------------------------------------------------------- {{{

" Set the space bar as the leader key.
" Changed from backslash (\) to space for easier access.
" The leader key is used to prefix custom mappings.
let mapleader = " "

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
" Quick search in file
nnoremap <leader>/ :/\<CR>
" Quick search backwards in file
nnoremap <leader>? :?\<CR>
" Replace in file
nnoremap <leader>rg :%s///g?<CR>
" Replace all in file
nnoremap <leader>R :%s///g<CR>
" Toggle spell check
nnoremap <leader>sp :set spell!<CR>
" Toggle paste mode
nnoremap <leader>p :set paste!<CR>

" Removed: Press \p to print to printer (Linux-only, doesn't work on macOS)
" Use system terminal commands instead for printing on macOS.
" Alternative: nnoremap <leader>p :terminal !lp<CR>

" Type jj to exit insert mode quickly.
" Common vim practice - escape with jj instead of escaping the key.
inoremap jj <Esc>

" Press the space bar to type the : character in command mode.
" Quick access to commands when you need to type them.
nnoremap <space> :

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

" NERDTree specific mappings.
" Map the F3 key to toggle NERDTree open and close.
nnoremap <F3> :NERDTreeToggle<cr>

" Have nerdtree ignore certain files and directories.
" Keep your file tree clean by hiding unnecessary files.
let NERDTreeIgnore=['\.git$', '\.jpg$', '\.mp4$', '\.ogg$', '\.iso$', '\.pdf$', '\.pyc$', '\.odt$', '\.png$', '\.gif$', '\.db$']

" NERDTree enhanced mappings
nnoremap <leader>e :NERDTree<CR>
nnoremap <leader>te :NERDTreeToggle<CR>
nnoremap <leader>cd :NERDTree CDir<CR>
nnoremap <leader>fu :NERDTree Find<CR>

" ALE specific mappings
" Toggle ALE quiet mode
nnoremap <leader>aq :set ALEWarnUnusedImports! ALEWarnUnusedVariable! ALEWarnUnusedSyntax!<CR>

" FZF (fuzzy finder) integration
" Requires fzf.vim plugin
" Navigate files with fuzzy search
nnoremap <leader>ff :Files<CR>
" Navigate buffers with fuzzy search
nnoremap <leader>fb :Buffers<CR>
" Navigate commands with fuzzy search
nnoremap <leader>fc :Commands<CR>
" Select recent changes with fuzzy search
nnoremap <leader>fr :RecentChanges<CR>

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

" Display cursorline and cursorcolumn ONLY in active window.
" When you switch windows, turn off cursor highlighting in the inactive window.
" This reduces visual clutter when managing multiple splits.
augroup cursor_off
    autocmd!
    autocmd WinLeave * set nocursorline nocursorcolumn
    autocmd WinEnter * set cursorline cursorcolumn
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
