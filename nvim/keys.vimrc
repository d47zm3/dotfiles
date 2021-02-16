" Leader Key
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
