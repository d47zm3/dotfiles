" Auto Install Plug
"
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !mkdir -p ~/.config/nvim/autoload
  silent !mkdir -p ~/.vim/swp
  silent !mkdir -p ~/.vim/undodir
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

let g:coc_global_extensions = [
\ 'coc-yaml',
\ 'coc-json',
\ 'coc-python',
\ 'coc-html',
\ 'coc-css',
\ 'coc-yaml',
\ 'coc-highlight',
\ ]


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
Plug 'neoclide/coc.nvim', {'branch': 'release' , 'do': { -> coc#util#install() }}

" Neomake
Plug 'neomake/neomake'

" EditorConfig
Plug 'editorconfig/editorconfig-vim'

" Colorschemes
Plug 'fatih/molokai'
Plug 'joshdick/onedark.vim'

" Go
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

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

" Auto Pairs
Plug 'jiangmiao/auto-pairs'

" Terraform
Plug 'hashivim/vim-terraform'
Plug 'rhadley-recurly/vim-terragrunt'

call plug#end()

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
