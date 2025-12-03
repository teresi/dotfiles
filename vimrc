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
let mapleader = ' '

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
Plugin 'preservim/nerdtree'                     " file explorer `:NERDTree` (F2)
Plugin 'preservim/tagbar'                       " browse tags (class structure etc.) (F8)
Plugin 'Yggdroot/indentLine'                    " show indentation levels
Plugin 'dense-analysis/ale'                     " Linter
Plugin 'airblade/vim-gitgutter'                 " show git status +/0 on side
Plugin 'vim-airline/vim-airline'                " status bar
Plugin 'rbgrouleff/bclose.vim'                  " `:BClose` bd but no close win
Plugin 'danro/rename.vim'                       " `:rename <fname>` rename file
Plugin 'Chiel92/vim-autoformat'                 " format buffer w/ :Autoformat et. al
Plugin 'tpope/vim-surround'                     " change surrounding pairs (e.g. '')
Plugin 'tpope/vim-dispatch'                     " `:Make!` for async `:make`
Plugin 'tpope/vim-unimpaired'                   " quickfix bindings, e.g. ]q (cnext), [q (cprevious)
Plugin 'tpope/vim-fugitive'                     " git tools
Plugin 'rbong/vim-flog'                         " git graph (:Flog -all)
Plugin 'ojroques/vim-oscyank'                   " clipboard overr SSH

" colors
Plugin 'taxilian/herald.vim'                    " 'herald' color scheme
Plugin 'vim-airline/vim-airline-themes'         " status bar colors
Plugin 'vim/colorschemes'                       " various color schemes

" languages
Plugin 'rhysd/vim-clang-format'                 " format C w/ `:ClangFormat`
Plugin 'lervag/vimtex'                          " LaTeX syntax
Plugin 'rust-lang/rust.vim'                     " Rust basics: syntastic, :RustFmt, tagbar
Plugin 'octol/vim-cpp-enhanced-highlight'       " c/c++ highlighting
Plugin 'ekalinin/Dockerfile.vim'                " dockerfile highlighting
Plugin 'vim-python/python-syntax'               " python highlighting
Plugin 'lambdalisue/vim-cython-syntax'          " cython highlighting
Plugin 'sheerun/vim-polyglot'                   " various language highlighting
Plugin 'uarun/vim-protobuf'                     " protobuf syntax highlighting
Plugin 'elzr/vim-json'                          " json syntax highlighting
Plugin 'zchee/vim-flatbuffers'                  " flatbuffer syntax highlighting

" future
"Plugin 'christoomey/vim-tmux-navigator'         " navigate tmux / vim splits
"Plugin 'neoclide/coc.nvim'                      " auto complete
"Plugin 'xolox/vim-colorscheme-switcher'         " switch color w/ F8 / SHIFT F8
"Plugin 'xolox/vim-misc'                         " dependency for ^

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
" show classes and etc. on right hand side
nnoremap <F8> :TagbarToggle<CR>

" TAB in general mode will move to text buffer
nnoremap <TAB> :bnext<CR>
" SHIFT-TAB will go back
nnoremap <S-TAB> :bprevious<CR>

" tabbing a visual block more than once
vnoremap < <gv
vnoremap > >gv


" " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " "
" TERMINAL

set shell=bash                 " :term default to bash

" Function keys that start with an <Esc> are recognized in Insert
" mode.  When this option is off, the cursor and function keys cannot be
" used in Insert mode if they start with an <Esc>.  The advantage of
" this is that the single <Esc> is recognized immediately, instead of
" after one second.  Instead of resetting this option, you might want to
" try changing the values for 'timeoutlen' and 'ttimeoutlen'.  Note that
" when 'esckeys' is off, you can still map anything, but the cursor keys
" won't work by default.
set noesckeys

" clipboard support may require (apt) `vim-gnome`
" you should see `+clipboard` and/or `+xterm_clipboard` in:
" `vim --version | grep clipboard`
set clipboard=unnamedplus      " use system clipboard as default register

set ttyfast                    " speedup editing
set lazyredraw                 " speedup editing


" " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " "
" VISUALIZATION

syntax enable
set background=dark
silent! colorscheme ron        " default color
"silent! colorscheme herald     " next color if downloaded
silent! colorscheme wildcharm  " next color if downloaded

"let g:airline_theme='base16_chalk'
" colors in docker get messed up somehow? (not even in tmux)
" so use 'deus' since that one is consistent
let g:airline_theme='deus'

" match indentline colors
"highlight SpecialKey ctermfg=239    " change color of whitespace chars
set number          " show line numbers
set hlsearch        " show highlighted search
set title           " show title in window bar
set cursorline      " highlight current line
set tw=0            " do not automatically break lines at certain length

" fix colors for showing current line and line numbers
" 234 matches the grey background
" see https://vim.fandom.com/wiki/Xterm256_color_names_for_console_Vim
"highlight CursorLine ctermbg=232
"highlight CursorLineNr ctermbg=232
"highlight LineNr ctermbg=232

" show relative numbers on active window
:set number relativenumber
:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

" highlight column limit on active window
"highlight ColorColumn ctermbg=White
"let HIGHLIGHT_COLS=89                        "overwrite this in local .vimrc for per project setting
"function! HighlightColumn( LIMIT )
"	let l:expr = '\%' . a:LIMIT . 'v.'
"	call matchadd('ColorColumn', l:expr, 100)
"endfunc
"augroup column_highlighting
"	autocmd!
"	let ft_to_ignore = ['floggraph']
"	autocmd BufEnter,WinEnter,FocusGained * if index(ft_to_ignore, &ft) < 0 | silent! call HighlightColumn(HIGHLIGHT_COLS) endif
"	autocmd BufEnter,WinEnter,FocusGained * IndentLinesEnable
"	autocmd BufLeave,WinLeave,FocusLost * if index(ft_to_ignore, &ft) < 0 | silent! call clearmatches()
"augroup END

" Yggdroot indentline, display indentation
let g:indentLine_char_list = ['|', '¦', '┆', '┊']  " cycle w/ different 'character' per indent level, utf-8 only!
let g:conceallevel = 1                             " turn on conceal so the indentation displays
let g:indentLine_conceallevel = 1                  " default conceal so it displays the indents

" Yggdroot indentline, disable for filetypes that should not have the code concealed
let g:indentLine_fileTypeExclude = ['tex', 'cls', 'md', 'json']
autocmd BufEnter *.tex set conceallevel=0
autocmd BufEnter *.cls set conceallevel=0
autocmd BufEnter *.md set conceallevel=0
autocmd BufEnter *.json set conceallevel=0

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

set tabstop=4
autocmd Filetype python,cython  setlocal tabstop=4 shiftwidth=4 expandtab
autocmd FileType c,cpp          setlocal tabstop=4 shiftwidth=4 softtabstop=4 cindent
autocmd FileType tex            setlocal tabstop=4 shiftwidth=4 softtabstop=4 cindent
autocmd FileType make           setlocal tabstop=4 shiftwidth=8 softtabstop=0 noexpandtab
autocmd FileType sh,bash        setlocal tabstop=4 shiftwidth=4 softtabstop=4
autocmd FileType yaml,yml       setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab


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

" default LaTeX style
let g:tex_flavor = 'latex'
"let g:vimtex_view_general_viewer = 'zathura'

" remove trailing whitespace
function TrimWhiteSpace()
	%s/\s*$//
	''
endfunction

autocmd FileWritePre    * call TrimWhiteSpace()
autocmd FileAppendPre   * call TrimWhiteSpace()
autocmd FilterWritePre  * call TrimWhiteSpace()
autocmd BufWritePre     * call TrimWhiteSpace()


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
let g:ale_echo_delay = 500         " mitigate cursor disappears on lines /w errors
let g:ale_sign_column_always = 1   " keep the gutter open
let g:ale_lint_on_save = 1         " return on save (default true)
let g:ale_set_loclist = 1          " use loclist for ale results (default 1)
let g:ale_set_quickfix = 0         " use quickfix for ale results (default 0)
let g:airline#extensions#ale#enabled = 1

" ALE navigation/list of warnings
" NOTE w/ vim-unimpaired you can [l and ]l to goto prev/next on loclist
nmap <silent> <S-k> <Plug>(ale_previous_wrap)
nmap <silent> <S-j> <Plug>(ale_next_wrap)
noremap <Leader>a :ALELint<CR>

noremap <Leader>l :call LLocToggle()<CR>
function! LLocToggle()
  if exists("g:loclist_win")
    lclose
    unlet g:loclist_win
  else
    lopen
    let g:loclist_win = bufnr("$")
  endif
endfunction


" " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " "
" FIXES

set nocompatible              " needed at the end to re-enable arrows in insert mode
set term=xterm-256color       " needed at the end to re-enable HOME/END (and fix colors)

" listchars were getting clobbered by something, so add to the end
" show whitespace
set list lcs=tab:¦\ ,trail:·,precedes:«,extends:»
