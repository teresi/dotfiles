"     s                                          .x+=:.      .
"    :8                                         z`    ^%    @88>
"   .88                  .u    .                   .   <k   %8P
"  :888ooo      .u     .d88B :@8c       .u       .@8Ned8"    .
"-*8888888   ud8888.  ="8888f8888r   ud8888.   .@^%8888"   .@88u
"  8888    :888'8888.   4888>'88"  :888'8888. x88:  `)8b. ''888E`
"  8888    d888 '88%"   4888> '    d888 '88%" 8888N=*8888   888E
"  8888    8888.+"      4888>      8888.+"     %8"    R88   888E
" .8888Lu= 8888L       .d888L .+   8888L        @8Wou 9%    888E
" ^%888*   '8888c. .+  ^"8888*"    '8888c. .+ .888888P`     888&
"   'Y"     '88888%       'Y'       '88888%   `   ^"F       R888"
"             'YP'                    'YP'                   ''

set encoding=utf-8
scriptencoding utf-8
set nocompatible              " be iMproved, required
filetype off                  " required
set exrc                      " load vimrc from working directory
set secure                    " limit commands from non-default vimrc files

augroup reload_vimrc          " auto load on change
	autocmd!
	autocmd bufwritepost $MYVIMRC nested source $MYVIMRC
augroup END


" " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " "
" PACKAGES

set rtp+=~/.vim/bundle/Vundle.vim               " add vundle to runtime path
call vundle#begin()                             " initialize vundle
"call vundle#begin('~/some/path/here')          " or set a plugin install dir

Plugin 'VundleVim/Vundle.vim'                   " use Vundle, required

" tools
Plugin 'preservim/nerdtree'                     " file explorer `:NERDTree`
Plugin 'preservim/tagbar'                       " browse tags (class structure etc.)
Plugin 'Yggdroot/indentLine'                    " show indentation levels
Plugin 'tpope/vim-fugitive'                     " git tools
Plugin 'rbong/vim-flog'                         " git graph
Plugin 'dantler/vim-alternate'                  " switch h/cpp (e.g. w/ `:A`)  FUTURE switch to ton/vim-alternate?
Plugin 'dense-analysis/ale'                     " Linter
Plugin 'airblade/vim-gitgutter'                 " show git status +/0 on side
Plugin 'rhysd/vim-clang-format'                 " format C w/ `:ClangFormat`
Plugin 'vim-airline/vim-airline'                " status bar
Plugin 'rbgrouleff/bclose.vim'                  " `:BClose` bd but no close win
Plugin 'danro/rename.vim'                       " `:rename <fname>` rename file
Plugin 'lervag/vimtex'                          " LaTeX language
Plugin 'gregsexton/gitv'                        " gitk in vim
Plugin 'JamshedVesuna/vim-markdown-preview'     " markdown preview
Plugin 'Chiel92/vim-autoformat'                 " format buffer w/ :Autoformat et. al
Plugin 'tpope/vim-surround'                     " change surrounding pairs (e.g. '')
Plugin 'tpope/vim-dispatch'                     " `:Make!` for async `:make`
Plugin 'tpope/vim-unimpaired'                   " quickfix bindings, e.g. ]q (cnext), [q (cprevious)
"Plugin 'neoclide/coc.nvim'                      " auto complete

" colors
Plugin 'taxilian/herald.vim'                    " 'herald' color scheme
Plugin 'vim-airline/vim-airline-themes'         " status bar colors
Plugin 'octol/vim-cpp-enhanced-highlight'       " c/c++ highlighting
Plugin 'ekalinin/Dockerfile.vim'                " dockerfile highlighting
Plugin 'vim-python/python-syntax'               " python highlighting
Plugin 'elzr/vim-json'                          " json syntax highlighting
Plugin 'uarun/vim-protobuf'                     " protobuf syntax highlighting

" future
"Plugin 'itchyny/lightline.vim'                  " status line, bottom
"Plugin 'mengelbrecht/lightline-bufferline'      " buffer list, top
"Plugin 'itchyny/vim-gitbranch'                  " lightline gitbranch#name() func
"Plugin 'severin-lemaignan/vim-minimap'          " show minimap sidebar
"Plugin 'christoomey/vim-tmux-navigator'         " navigate tmux / vim splits
"Plugin 'git://github.com/majutsushi/tagbar.git' " class outline viewer

" old
"Plugin 'flazz/vim-colorschemes'                 " colors
"Plugin 'xolox/vim-colorscheme-switcher'         " switch color w/ F8 / SHIFT F8
"Plugin 'xolox/vim-misc'                         " dependency for ^
"Plugin 'joshdick/onedark.vim'                   " color, atom onedark

call vundle#end()            " required, all plugins must be added before this
filetype plugin indent on    " required


" " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " "
" SHORTCUTS

" split navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" show file tree
nnoremap <F2> :NERDTreeToggle<CR>
" format the buffer
nnoremap <F3> :Autoformat<CR>

nnoremap <F8> :TagbarToggle<CR>

" TAB in general mode will move to text buffer
nnoremap <TAB> :bnext<CR>
" SHIFT-TAB will go back
nnoremap <S-TAB> :bprevious<CR>

" tabbing a visual block more than once
vnoremap < <gv
vnoremap > >gv


" " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " "
" MARKDOWN PREVIEW 'JamshedVesuna/vim-markdown-preview'
" apt-get install xdotool
" pip install grip

let vim_markdown_preview_toggle=3  " show markdown on write, no images
let vim_markdown_preview_github=1


" " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " "
" TERMINAL

set shell=bash                 " :term default to bash
"let g:Terminal_FastMode = 0   " 'tc50cal/vim-terminal' for speed
"let g:Terminal_PyVersion = 3  " 'tc50cal/vim-terminal'

" Function keys that start with an <Esc> are recognized in Insert
" mode.  When this option is off, the cursor and function keys cannot be
" used in Insert mode if they start with an <Esc>.  The advantage of
" this is that the single <Esc> is recognized immediately, instead of
" after one second.  Instead of resetting this option, you might want to
" try changing the values for 'timeoutlen' and 'ttimeoutlen'.  Note that
" when 'esckeys' is off, you can still map anything, but the cursor keys
" won't work by default.
set noesckeys

" " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " "
" EDITOR

" clipboard support may require (apt) `vim-gnome`
" you should see `+clipboard` and/or `+xterm_clipboard` in:
" `vim --version | grep clipboard`
set clipboard=unnamedplus      " use system clipboard as default register

set ttyfast                    " speedup editing
set lazyredraw                 " speedup editing

" also add this to .tmux.conf:    set -g default-terminal 'screen-256color'
set term=screen-256color   " fix colors for vim inside tmux

syntax enable
set background=dark
silent! colorscheme ron        " default color
silent! colorscheme herald     " next color if downloaded
"let g:airline_theme='base16_chalk'
" colors in docker get messed up somehow? (not even in tmux)
" so use 'deus' since that one is consistent
let g:airline_theme='deus'


" show whitespace
"set listchars=trail:\uB7,nbsp:~,eol:\u23CE
"set list lcs=trail:\uB7,tab:\uBB\uB7
"set list lcs=trail:\uB7,tab:»·
"set list lcs=trail:·,precedes:«,extends:»,eol:↲,tab:▸\ 
"set list lcs=trail:·,precedes:«,extends:»,eol:⏎,tab:▸\ 
"set list lcs=tab:▸\ ,trail:·,precedes:«,extends:»
set list lcs=tab:¦\ ,trail:·,precedes:«,extends:»
" match indentline colors
highlight SpecialKey ctermfg=239
set number          " show line numbers
set hlsearch        " show highlighted search
set title           " show title in window bar
set cursorline      " highlight current line
set tw=0            " do not automatically break lines at certain length

" show relative numbers on active window
:set number relativenumber
:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

" highlight column limit on active window
highlight ColorColumn ctermbg=DarkBlue
let HIGHLIGHT_COLS=89                        "overwrite this in local .vimrc for per project setting
"function! HighlightColumn( LIMIT )
"	let l:expr = '\%' . a:LIMIT . 'v.'
"	call matchadd('ColorColumn', l:expr, 100)
"endfunc
"augroup column_highlighting
"	autocmd!
"	let ft_to_ignore = ['floggraph']
"	autocmd BufEnter,WinEnter,FocusGained * if index(ft_to_ignore, &ft) < 0 | silent! call HighlightColumn(HIGHLIGHT_COLS) endif
"	autocmd BufLeave,WinLeave,FocusLost * if index(ft_to_ignore, &ft) < 0 | silent! call clearmatches()
"augroup END


" default LaTeX style
let g:tex_flavor = 'latex'

" indent line resets conceallevel on load, so fix for LaTeX
let g:indentLine_fileTypeExclude = ['tex', 'cls']

" don't hide unicode / escape char
let g:conceallevel = 0

" enable line numbers in NERDTree
let NERDTreeShowLineNumbers=1
autocmd FileType nerdtree setlocal relativenumber

" " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " "
" NAVIGATION

set splitbelow                   " new split to bottom
set splitright                   " new split to right
set path+=**                     " add working dir to search :find
set wildmenu                     " turn on tab completion for :find
set wildignore+=**/.git/**       " ignore git folders
set hidden                       " allow buffer switch w/o save


" " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " "
" LANGUAGES

autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4
autocmd FileType c,cpp setlocal tabstop=4 shiftwidth=4 softtabstop=4 cindent
autocmd FileType tex setlocal tabstop=4 shiftwidth=4 softtabstop=4 cindent


" LaTeX commands and symbols can get converted to unicode, so disable that
autocmd BufEnter *.tex set conceallevel=0


augroup debianlatexfix
  " Remove all vimrc autocommands within scope
  autocmd!
  autocmd BufNewFile,BufRead *.tex   set syntax=tex
  autocmd BufNewFile,BufRead *.cls   set syntax=tex
augroup END


" plugin 'indentLine' changes the 'conceallevel' from the default
" change the settings for json files so it doesn't squash characters
autocmd Filetype json let g:indentLine_enabled = 0


" use xml colors for ros launch
augroup roslaunch
	au!
	autocmd BufNewFile,BufRead *.launch   set syntax=xml
augroup END
"let g:indent_guides_enable_on_vim_startup = 1


" " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " "
" VIM DISPATCH / QUICKFIX

" add a key to toggle quickfix window 'yoq'
" this follows the style for the unimpaired option toggling (yoX)
" SEE:  https://github.com/tpope/vim-unimpaired/blob/master/doc/unimpaired.txt
" SEE:  https://github.com/tpope/vim-unimpaired/issues/97
function! ToggleQuickFix()
    if getqflist({'winid' : 0}).winid
        cclose
    else
        copen
    endif
endfunction
command! -nargs=0 -bar ToggleQuickFix call ToggleQuickFix()
nnoremap yoq :ToggleQuickFix<CR>


" " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " "
" CLIP BOARD

" BUG gnome-terminal does not support OSC52, so this is untested
"function! OscCopy()  " copy contents yanked into OS clipboard
"  let encodedText=@"
"  let encodedText=substitute(encodedText, '\', '\\\\', "g")
"  let encodedText=substitute(encodedText, "'", "'\\\\''", "g")
"  let executeCmd="echo -n '".encodedText."' | base64 | tr -d '\\n'"
"  let encodedText=system(executeCmd)
"  if $TMUX != ""
"    "tmux
"    let executeCmd='echo -en "\x1bPtmux;\x1b\x1b]52;;'.encodedText.'\x1b\x1b\\\\\x1b\\" > /dev/tty'
"  else
"    let executeCmd='echo -en "\x1b]52;;'.encodedText.'\x1b\\" > /dev/tty'
"  endif
"  call system(executeCmd)
"  redraw!
"endfunction
"command! OscCopy :call OscCopy()


"" " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " "
"" LIGHTLINE (status line on bottom)
"
"set laststatus=2                                     " show status line
"set guioptions-=e                                    " don't use gui tabline
"" SEE `:h g:lightline.component`
"let g:lightline = {
"      \   'active': {
"      \   'left': [ [ 'mode', 'paste' ],
"      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
"      \   'right': [ [ 'lineinfo', 'syntastic' ],
"      \              [ 'percent' ],
"      \              [ 'filetype' ] ]
"      \ },
"      \ 'component_function': {
"      \   'gitbranch': 'gitbranch#name'
"      \ },
"      \   'colorscheme': 'wombat',
"      \ }
"
""let g:lightline.separator = {
""      \   'left': '', 'right': ''
""      \}
"let g:lightline.subseparator = {
"      \   'left': '', 'right': ''
"      \}
"let g:lightline.colorscheme = 'onedark'
"
"" TODO (?) add customizations for better tabs from:
"" https://github.com/NovaDev94/lightline-onedark
"" TODO (?) add tmux colors to compliment onedark from:
"" https://github.com/odedlaz/tmux-onedark-theme
"
"" " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " "
"" LIGHTLINE-BUFFERLINE (buffer list on top)
"
"set showtabline=2                                    " show tabline (top buffer list)
"let g:lightline#bufferline#show_number  = 1          " prepend buffer number
""let g:lightline#bufferline#shorten_path = 1          " abbreviate paths
"let g:lightline#bufferline#filename_modifier = ':t'  " no path in buf filename
"let g:lightline#bufferline#unnamed = '[No Name]'
"let g:lightline.tabline = {'left': [['buffers']], 'right': [['tabs']]}
"let g:lightline.component_expand = {'buffers': 'lightline#bufferline#buffers'}
"let g:lightline.component_type   = {'buffers': 'tabsel'}
"
"
" " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " "
" AIRLINE
set laststatus=2                                  " show airline
let g:airline_powerline_fonts = 1                 " requires `fonts-powerline`
let g:airline#extensions#whitespace#enabled = 0   " remove section on right
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'

" optimizations
" test `:profile start <ouput.log>` && `:profile func *` && `:profile file *"
" use vim
" read `:profile pause` && `:e <output.log>
let g:airline_extensions = ['tabline']            " whitelist (massive speedup)
let g:airline#extensions#tabline#enabled = 1      " enable list of buffers
let g:airline#extensions#tabline#fnamemod = ':t'  " buffername is just filename
let g:airline#extensions#branch#enabled = 0       " off, speedup airline
let g:airline#extensions#syntastic#enabled = 0    " off, speedup airline
let g:airline#extensions#fugitiveline#enabled = 0 " off, speedup airline
let g:airline_highlighting_cache = 1              " on, speedup airline

" airline unicode, requires:    # apt-get install fonts-powerline
if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif
let g:airline_left_sep = ''
let g:airline_right_sep = ''
"let g:airline_symbols.linenr = '␊'
"let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.whitespace = 'Ξ'
let g:airline_left_alt_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

" remove specific airline symbols
let g:airline_symbols.linenr = ''  " ¶
let g:airline_symbols.maxlinenr = ''  " '
let g:airline_left_sep = ''  " 
let g:airline_right_sep = ''  " 
let g:airline_left_alt_sep = ''  " ''
let g:airline_right_alt_sep = ''  " ''
let g:airline_symbols.branch = ''  " ''


" " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " "
" CoC
"source $HOME/.config/vim/plug-config/coc.vim
"hi Pmenu ctermbg=black ctermfg=white
"set signcolumn=yes  " fix issue where CoC messes up git gutter spacing
"set cmdheight=1     " fix issue where CoC sets 2 lines for cmdheight


" " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " "
" ALE

" NOTE not an issue on Vim8.1+?
let g:ale_echo_delay = 500  " mitigate cursor disappears on lines /w errors
