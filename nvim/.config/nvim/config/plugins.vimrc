" Set Python Paths
let g:python_host_prog = '/usr/local/bin/python2'
let g:python3_host_prog = '/usr/local/bin/python3'

" neomake
autocmd! BufWritePost * Neomake
let g:neomake_open_list = 2
let g:neomake_verbose = 3
let g:neomake_javascript_enabled_makers=['xo']
let g:neomake_jsx_enabled_makers = ['xo']
let g:neomake_javascript_xo_maker={
      \ 'args': ['--reporter=compact'],
      \ 'errorformat': '%E%f: line %l\, col %c\, Error - %m,' .
      \ '%W%f: line %l\, col %c\, Warning - %m'
      \ }

