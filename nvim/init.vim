" ================================
" Most Important Keyboard Mappings
" ================================
"
" CTRL+w+w to switch between open windows
"
" === NERDTree
"
" 'CTRL+n' to open explorer
" 't' to open file in new tab
" 's' to open file in vertically split window (side-by-side)
" 'i' to open file in horizontal split pane (above current window)
"
" === FZF
"
" :FZF / FZF~ - start search (make mapping?)
" CTRL+t - open selected file in new tab
"
" === Git Gutter
"
" [c and ]c - jump between hunks
" preview hunk - <leader>hp
" stage hunk - <leader>hs
" undo hunk - <leader>hu
" toggle hihlighted lines - <leader>ht
"
" === Vimagit
" <leader>M - open buffer
"
" === Surround
" cs"' - change " to '
" ds" - remove "
" yss" - wrap entire line
" ys2w" - wrap next 2 words in \" -  add (y) 's'urrounding 3 words with "
"
" ==============
" Global Options
" ==============
"
" Don't Try To Be VI Compatible
set nocompatible

" Set Encoding
set encoding=utf-8
" Allow To Switch Between Unsaved Buffers
set hidden
'
" Enable Syntax Highlight
syntax on
" Allow Backspacing Over Indention, Line Breaks And Insertion Start.
set backspace=indent,eol,start
" Bigger History
set history=1000
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
set directory=$HOME/.vim/swp//
" Maintain Persistent Undo
set undofile
set undodir=$HOME/.vim/undodir
" Update Sign Column Often For Git Gutter
set updatetime=250

" Highlight Trailing Whitespace
match ErrorMsg '\s\+$'
" Remove Trailing Whitespaces Automatically
autocmd BufWritePre * :%s/\s\+$//e

" ===============
" Hacking Section
" ===============
" Auto Install Plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !mkdir -p ~/.config/nvim/autoload
  silent !mkdir -p ~/.vim/swp
  silent !mkdir -p ~/.vim/undodir
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

" ================
" Plugins Section
" ================
"
" Install Plugins
call plug#begin('~/.config/nvim/plugged')

" Airline Addons
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Conqueror Of Completion
Plug 'neoclide/coc.nvim', {'tag': '*', 'branch': 'release'}

" Jedi VIM
" Plug 'davidhalter/jedi-vim'

" Python Mode
" Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }

" Molokai Colorscheme
Plug 'fatih/molokai'
Plug 'joshdick/onedark.vim'

" Go
Plug 'fatih/vim-go'

" Vim Polyglot - Collection Of Language Packs
Plug 'sheerun/vim-polyglot'

" NerdTREE
Plug 'scrooloose/nerdtree'

" NerdTREE Git Plugin
Plug 'Xuyuanp/nerdtree-git-plugin'

" FZF
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" GIT Gutter
Plug 'airblade/vim-gitgutter'

" Fugitive
Plug 'tpope/vim-fugitive'

" Vimagit - fill lacks of Fugitive
Plug 'jreybert/vimagit'

" Surround
Plug 'tpope/vim-surround'

" Tags
" Plug 'ludovicchabant/vim-gutentags'
" Plug 'majutsushi/tagbar'

" Auto Pairs
Plug 'jiangmiao/auto-pairs'

" if has('nvim')
"   Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" else
"   Plug 'Shougo/deoplete.nvim'
"   Plug 'roxma/nvim-yarp'
"   Plug 'roxma/vim-hug-neovim-rpc'
" endif
" let g:deoplete#enable_at_startup = 1
"

" Terraform
Plug 'hashivim/vim-terraform'

call plug#end()

" ===============
" Hacking Section
" ===============
" Sync Plugins On Start
let s:need_install = keys(filter(copy(g:plugs), '!isdirectory(v:val.dir)'))
let s:need_clean = len(s:need_install) + len(globpath(g:plug_home, '*', 0, 1)) > len(filter(values(g:plugs), 'stridx(v:val.dir, g:plug_home) == 0'))
let s:need_install = join(s:need_install, ' ')
if has('vim_starting')
  if s:need_clean
    autocmd VimEnter * PlugClean!
  endif
  if len(s:need_install)
    execute 'autocmd VimEnter * PlugInstall --sync' s:need_install '| source $MYVIMRC'
    finish
  endif
else
  if s:need_clean
    PlugClean!
  endif
  if len(s:need_install)
    execute 'PlugInstall --sync' s:need_install '| source $MYVIMRC'
    finish
  endif
endif


" Prevent From Using I-Block Cursor
set guicursor=
autocmd OptionSet guicursor noautocmd set guicursor=

" ==================================
" Default VIM File Explorer Settings
" ==================================
"
" Open New File In Right Buffer By Default
let g:netrw_browse_split = 4
" Keep It To 10% Of Window (Widescreen)
let g:netrw_winsize = 10

" ===================
" Appearance
" ===================
"" Set Colorscheme
set t_Co=256
set background=dark
let g:rehash256 = 1
set termguicolors
colorscheme onedark
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

" Jenkinsfile Syntax Highlight
au BufNewFile,BufRead Jenkinsfile setf groovy
au BufNewFile,BufRead *jenkinsfile setf groovy

" HCL Syntax Highlight
au BufNewFile,BufRead *.hcl setf terraform

" Automate Saving/Restoring Folds
" augroup auto_save_folds
" autocmd!
" autocmd BufWinLeave * mkview
" autocmd BufWinEnter * silent loadview - you can't load view for empty files

" Automate Line Number Show
augroup toggle_relative_number
autocmd InsertEnter * :setlocal norelativenumber
autocmd InsertLeave * :setlocal relativenumber

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" ===================
" Keyboard Mappings
" ===================
"
" Leader Key
" let mapleader = "\<Space>"
let mapleader = ","

" Switch Between Splits Using CTRL + J/K...
nnoremap <C-H> <C-W><C-H>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>

" Make . To Work With Visually Selected Lines
vnoremap . :normal.<CR>

" ,/ To Stop Highlight Searched Word
nmap <silent> ,/ :nohlsearch<CR>

" Jump Back To Last Edited Buffer
nnoremap <C-b> <C-^>
inoremap <C-b> <esc><C-^>


" Autocomplete With CTRL+b
inoremap <C-a> <C-x><C-o>

" Jedi VIM Python Mappings - For Reference
let g:jedi#goto_command = "<leader>d"
let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#goto_definitions_command = ""
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>n"
let g:jedi#completions_command = "<C-Space>"
let g:jedi#rename_command = "<leader>r"

" =========================
" Specific Plugins Settings
" =========================
let g:syntastic_python_pylint_post_args="--max-line-length=119"
let g:syntastic_always_populate_loc_list = 0
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:pymode_python = 'python3'
let g:pymode_lint_cwindow = 0
let g:pymode_options_max_line_length=119
let g:pymode_lint_options_pep8={'max_line_length': g:pymode_options_max_line_length}
let g:pymode_lint_options_pylint={'max-line-length': g:pymode_options_max_line_length}
let g:pymode_lint_on_fly = 1
let g:pymode_rope = 1
let g:pymode_rope_autoimport=1
let g:pymode_indent = 1




" How can I open a NERDTree automatically when vim starts up if no files were specified?
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" How can I open NERDTree automatically when vim starts up on opening a directory?
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
" How can I map a specific key or shortcut to open NERDTree?
map <C-n> :NERDTreeToggle<CR>
" Close NerdTREE after it open a file
let NERDTreeQuitOnOpen=1


" This is the default extra key bindings
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Default fzf layout
" - down / up / left / right
let g:fzf_layout = { 'down': '~40%' }

" In Neovim, you can set up fzf window using a Vim command
let g:fzf_layout = { 'window': 'enew' }
let g:fzf_layout = { 'window': '-tabnew' }
let g:fzf_layout = { 'window': '10new' }

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" FZF - WIP
nnoremap <leader><leader> :GFiles<CR>
nnoremap <leader>fi       :Files<CR>
nnoremap <leader>C        :Colors<CR>
nnoremap <leader><CR>     :Buffers<CR>
nnoremap <leader>fl       :Lines<CR>
nnoremap <leader>ag       :Ag! <C-R><C-W><CR>
nnoremap <leader>m        :History<CR>

" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir = '~/.local/share/fzf-history'

" Git Gutter
" Toggle Changed Line Highlight
nnoremap <leader>ht ::GitGutterLineHighlightsToggle<CR>

" Tagbar
nmap T :TagbarToggle<CR>

let g:gutentags_cache_dir = '~/.cache/nvim/gutentags'
let g:gutentags_file_list_command = {'markers': {'.git': 'git ls-files'}}
let g:gutentags_exclude = ['*.go']

" highlight python and self function
autocmd BufEnter * syntax match Type /\v\.[a-zA-Z0-9_]+\ze(\[|\s|$|,|\]|\)|\.|:)/hs=s+1
autocmd BufEnter * syntax match pythonFunction /\v[[:alnum:]_]+\ze(\s?\()/
hi def link pythonFunction Function
autocmd BufEnter * syn match Self "\(\W\|^\)\@<=self\(\.\)\@="
highlight self ctermfg=239

" close preview windows after completion
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

" workaround for issue https://github.com/fatih/vim-go/issues/2363
au FileType go let g:go_fmt_autosave = 1
let g:syntastic_go_checkers = ['go', 'golint', 'govet', 'errcheck']
au filetype go inoremap <buffer> . .<C-x><C-o>

"
" " Golang Mappings - find more at https://github.com/fatih/vim-go/blob/master/doc/vim-go.txt
" au FileType go nmap <leader>r <Plug>(go-run)
" au FileType go nmap <Leader>c <Plug>(go-coverage-toggle)
"
" " run :GoBuild or :GoTestCompile based on the go file
" function! s:build_go_files()
"   let l:file = expand('%')
"   if l:file =~# '^\f\+_test\.go$'
"     call go#test#Test(0, 1)
"   elseif l:file =~# '^\f\+\.go$'
"     call go#cmd#Build(0)
"   endif
" endfunction
"
" autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
"
" " vim-go
"
" " Disable null module warning - vim-go
" let g:go_null_module_warning = 0
"
" " Airline Theme
" let g:airline_theme='wombat'
"
" " Run goimports along gofmt on each save
" let g:go_fmt_command = "goimports"
"
" " Automatically get signature/type info for object under cursor
" let g:go_auto_type_info = 1
"
"
let g:go_list_type = "quickfix"
let g:go_fmt_command = "goimports"
let g:go_fmt_fail_silently = 0

let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_structs = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_space_tab_error = 0
let g:go_highlight_array_whitespace_error = 0
let g:go_highlight_trailing_whitespace_error = 0
let g:go_highlight_extra_types = 1

" CoC Config

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if has('patch8.1.1068')
  " Use `complete_info` if your (Neo)Vim version supports it.
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current line.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <TAB> for selections ranges.
" NOTE: Requires 'textDocument/selectionRange' support from the language server.
" coc-tsserver, coc-python are the examples of servers that support it.
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings using CoCList:
" Show all diagnostics.
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
