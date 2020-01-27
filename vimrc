scriptencoding utf-8
set encoding=utf-8

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" stats bar at the bottom
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'git://github.com/majutsushi/tagbar.git'
Plugin 'flazz/vim-colorschemes'
" show indent levels
Plugin 'Yggdroot/indentLine'
" show git branch
Plugin 'tpope/vim-fugitive'
Plugin 'xolox/vim-colorscheme-switcher'
Plugin 'xolox/vim-misc'
" colors
Plugin 'artanikin/vim-synthwave84'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" plugin 'indentLine' changes the 'conceallevel' from the default
" change the settings for json files so it doesn't squash characters
autocmd Filetype json let g:indentLine_enabled = 0

" use xml colors for ros launch
augroup roslaunch
	au!
	autocmd BufNewFile,BufRead *.launch   set syntax=xml
augroup END
"let g:indent_guides_enable_on_vim_startup = 1

" show whitespace
"set listchars=trail:\uB7,nbsp:~,eol:\u23CE
"set list lcs=trail:\uB7,tab:\uBB\uB7
"set list lcs=trail:\uB7,tab:»·
"set list lcs=trail:·,precedes:«,extends:»,eol:↲,tab:▸\ 
"set list lcs=trail:·,precedes:«,extends:»,eol:⏎,tab:▸\ 
set list lcs=tab:▸\ ,trail:·,precedes:«,extends:»

" set Python to 4 spaces indentations
autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4
" set C++ spaces/indents
autocmd FileType c,cpp setlocal tabstop=4 shiftwidth=4 softtabstop=4 cindent

set laststatus=2    " show airline
set number          " show line numbers
set hlsearch        " show highlighted search
set title           " show title in window bar
set cursorline      " highlight current line

colorscheme herald

" automatically load vimrc on change
augroup myvimrc
	au!
	au BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
augroup END

" highlight column limit
"highlight ColorColumn ctermbg=magenta
"call matchadd('ColorColumn', '\%81v', 88)
set colorcolumn=88
highlight ColorColumn ctermbg=0 guibg=lightgrey

" make airline faster
let g:airline_highlighting_cache = 0
" enable airline symbols
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif

" unicode symbols
" make sure to install:  # apt-get install fonts-powerline
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

" airline symbols, remove specific characters
let g:airline_left_sep = ''  " ''
let g:airline_right_sep = ''  " ''
let g:airline_symbols.linenr = ''  " ''
