" utilsnips trigger
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"


" Use ; for commands.
nnoremap ; :
" Use Q to execute default register.
nnoremap Q @q

" ack_or_silver_searcher
let g:ackprg = 'ag --vimgrep'

" Fuzzy Search
nnoremap <C-p> :FZF<CR>

" neomake
nmap <Leader><Space>o :lopen<CR>      " open location window
nmap <Leader><Space>c :lclose<CR>     " close location window
nmap <Leader><Space>, :ll<CR>         " go to current error/warning
nmap <Leader><Space>n :lnext<CR>      " next error/warning
nmap <Leader><Space>p :lprev<CR>      " previous error/warning

" Search settings
set hlsearch   " Highlight results
set ignorecase " Ignore casing of searches
set incsearch  " Start showing results as you type
set smartcase  " Be smart about case sensitivity when searching

" Tab settings
set expandtab     " Expand tabs to the proper type and size
set tabstop=4     " Tabs width in spaces
set softtabstop=4 " Soft tab width in spaces
set shiftwidth=4  " Amount of spaces when shifting

" Shortcut to yanking to the system clipboard
map <leader>y "*y
map <leader>p "*p

" Navigating tabs easier
map <D-S-{> :tabprevious
map <D-S-}> :tabprevious
