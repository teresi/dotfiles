" vimrc entry, basic config
" 
" provides overall essentials such as vundle / colors / settings
" intended to be sourced at the top of the vimrc
" i.e.: `:source $HOME/<filepath>


" " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " "
" BOILER PLATE
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

Plugin 'taxilian/herald.vim'                    " 'herald' color scheme
Plugin 'Yggdroot/indentLine'                    " show indentation levels
Plugin 'dantler/vim-alternate'                  " switch h/cpp (e.g. w/ `:A`)
Plugin 'airblade/vim-gitgutter'                 " show git status +/0 on side
Plugin 'scrooloose/syntastic'                   " syntax checking
Plugin 'vim-airline/vim-airline'                " status bar
Plugin 'vim-airline/vim-airline-themes'         " status bar colors
Plugin 'rbgrouleff/bclose.vim'                  " `:BClose` bd but no close win
Plugin 'danro/rename.vim'                       " `:rename <fname>` rename file
Plugin 'tpope/vim-surround'                     " change surrounding pairs (e.g. '')
"Plugin 'christoomey/vim-tmux-navigator'         " navigate tmux / vim splits

Plugin 'octol/vim-cpp-enhanced-highlight'       " c/c++ highlighting
Plugin 'ekalinin/Dockerfile.vim'                " dockerfile highlighting
Plugin 'vim-python/python-syntax'               " python highlighting
Plugin 'elzr/vim-json'                          " json syntax highlighting
Plugin 'uarun/vim-protobuf'                     " protobuf syntax highlighting

call vundle#end()                               " required, all plugins must be added before this
filetype plugin indent on                       " required


" " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " "
" 


syntax enable

set shell=bash                 " :term default to bash
"let g:Terminal_FastMode = 0   " 'tc50cal/vim-terminal' for speed
"let g:Terminal_PyVersion = 3  " 'tc50cal/vim-terminal'


" color
set background=dark
silent! colorscheme ron        " default color
silent! colorscheme herald     " next color if downloaded
let g:airline_theme='base16_chalk'


" clipboard support may require (apt) `vim-gnome`
" you should see `+clipboard` and/or `+xterm_clipboard` in:
" `vim --version | grep clipboard`
set clipboard=unnamedplus      " use system clipboard as default register

set ttyfast                    " speedup editing
set lazyredraw                 " speedup editing




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


