" Set Python Paths
let g:python_host_prog = '/usr/local/bin/python2'
let g:python3_host_prog = '/usr/local/bin/python3'



" tern & deoplete
if exists('g:plugs["tern_for_vim"]')
  let g:deoplete#omni#functions = {}
  let g:deoplete#omni#functions.javascript = [
    \ 'tern#Complete',
    \ 'jspc#omni'
  \]
endif

let g:deoplete#enable_at_startup = 1
let g:deoplete#sources = {}
let g:deoplete#sources['javascript.jsx'] = ['file', 'ultisnips', 'ternjs']

let g:tern#command = ['tern']
let g:tern#arguments = ['--persistent']

" close the preview window when you're not using it
let g:SuperTabClosePreviewOnPopupClose = 1

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

" neomake config
let g:neomake_place_signs = 0
let g:neomake_open_list = 2
let g:neomake_javascript_enabled_makers = ['xo']

" vim color scheme
syntax on
color dracula

" lightline color scheme
let g:lightline = {
      \ 'colorscheme': 'Dracula',
      \ }
