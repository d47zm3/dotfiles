let g:syntastic_python_pylint_post_args="--max-line-length=119"
let g:syntastic_always_populate_loc_list = 0
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_go_checkers = ['go', 'golint', 'govet', 'errcheck']
let g:pymode_python = 'python3'
let g:pymode_lint_cwindow = 0
let g:pymode_options_max_line_length=119
let g:pymode_lint_options_pep8={'max_line_length': g:pymode_options_max_line_length}
let g:pymode_lint_options_pylint={'max-line-length': g:pymode_options_max_line_length}
let g:pymode_lint_on_fly = 1
let g:pymode_rope = 1
let g:pymode_rope_autoimport=1
let g:pymode_indent = 1
