"" Set Colorscheme
set t_Co=256
let g:rehash256 = 1
colorscheme onedark
set background=dark

highlight Normal ctermbg=black
" Security
set modelines=0
" Show Number Lines
set number
" Show Ruler
set ruler
" Set Tabs/Shift
set tabstop=2 softtabstop=2 expandtab shiftwidth=2 smarttab
" Auto Indent
 filetype plugin indent on
" Don't Wrap Lines
set nowrap
" Number Of Lines To Keep Above And Below Cursor
set scrolloff=5
" Syntax Highlight
set syntax
" Show Matches In Center
nnoremap n nzz
nnoremap N Nzz
" Visualize Tabs And Newlines
set listchars=tab:▸\ ,eol:¬
" Enable Folding
set foldenable
" Open Most Of The Folds By Default. If Set To 0, All Folds Will Be Closed.
set foldlevelstart=10
" Folds Can Be Nested. Setting A Max Value Protects You From Too Many Folds.
set foldnestmax=10
" Defines The Type Of Folding.
set foldmethod=indent
" Visually Indicate Folds
set foldcolumn=2
" Various Languages Folding
let perl_fold=1
let perl_fold_blocks = 1
let sh_fold_enabled=1
let vimsyn_folding='af'
let r_syntax_folding=1
let ruby_fold=1
let php_folding=1
let javaScript_fold=1
let xml_syntax_folding=1

let g:airline_theme='onedark'

" Automate Line Number Show
augroup toggle_relative_number
autocmd InsertEnter * :setlocal norelativenumber
autocmd InsertLeave * :setlocal relativenumber

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" Jenkinsfile Syntax Highlight
au BufNewFile,BufRead Jenkinsfile setf groovy
au BufNewFile,BufRead *jenkinsfile setf groovy

" HCL Syntax Highlight
au BufNewFile,BufRead *.hcl setf terraform

" close preview windows after completion
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
