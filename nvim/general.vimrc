" Don't Try To Be VI Compatible
set nocompatible
" Set Encoding
set encoding=utf-8
" Allow To Switch Between Unsaved Buffers
set hidden
" Enable Syntax Highlight
syntax on
" Allow Backspacing Over Indention, Line Breaks And Insertion Start.
set backspace=indent,eol,start
" Bigger History
set history=10000
" Show Current Mode
set showmode
" Show Incomplete Commands
set showcmd
" Always Show Status Bar
set laststatus=2
" Show Cursor Position
set ruler
" Display Command Line Tab Complete Options As A Menu
set wildmenu
" Disable Error Bells
set noerrorbells
" Enable Mouse
set mouse=a
" No Backup File
set nobackup
" Swap Files In One Location
set directory=$HOME/.vim/swp/
" Maintain Persistent Undo
set undofile
set undodir=$HOME/.vim/undodir
" Update Sign Column Often For Git Gutter
set updatetime=250
" Highlight Trailing Whitespace
match ErrorMsg '\s\+$'
" Remove Trailing Whitespaces Automatically
autocmd BufWritePre * :%s/\s\+$//e
" Prevent From Using I-Block Cursor
set guicursor=
autocmd OptionSet guicursor noautocmd set guicursor=
