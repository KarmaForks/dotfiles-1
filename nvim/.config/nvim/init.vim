" vim: set foldmethod=marker foldlevel=0:
" ============================================================================
" Jon Leopard's .vimrc {{{
" ============================================================================

" }}}
" ============================================================================
" BASIC SETTINGS {{{
" ============================================================================

let mapleader = ' '                       " Map  <leader> key to space
let maplocalleader = ' '                  " Map local leader to space
set nu
set autoindent
set smartindent
set autoread                              " Auto-reload modified files
set encoding=utf-8                        " Encode characters as utf-8
set fileencoding=utf-8                    " Encode files as utf-8
set termencoding=utf-8                    " Set encoding used for the terminal
set foldmethod=marker                     " Fold based on specified markers
set hlsearch                              " Highlight results
set ignorecase smartcase                  " Ignore the case in regexes | override ignorecase if an uppercase is typed
set wildmenu
set wildmode=full
set incsearch                             " Enable incremental search
set lazyredraw                            " For better performance when replaying macros
let &showbreak= '4 '                      " Show that a line has been wrapped
set breakindent
set breakindentopt=sbr
set nojoinspaces                          " Avoid double spaced when joining lines
set formatoptions+=1                      " Don't wrap after a 1 letter word, wrap before
set formatoptions+=j
set foldlevelstart=99
set showcmd
set backspace=indent,eol,start
set nocursorline
set diffopt=filler,vertical
set completeopt=menuone,preview
set hidden                                " Hide buffers instead of closing them
set history=500                           " Rememebr command mode history
set laststatus=2                          " Always show the status bar. Airline requires this.
set list                                  " Show invisible characters
set listchars=tab:\|\ ,                   " Set the characters for the invisibles
set virtualedit=block
set scrolloff=5                           " Keep the cursor centered in the screen
set showmode                              " Show the current mode on the open buffer
set visualbell                            " Use a visual bell to notify us
set expandtab smarttab                    " Expand tabs to the proper type and size
set tabstop=2                             " Tabs width in spaces
set shiftwidth=2                          " Amount of spaces when shifting
set synmaxcol=1000                        " Don't try to syntax highlight minified files"
set timeoutlen=500
set modelines=2
let g:netrw_localrmdir='rm -r'            " Allow deletion of a dir that isn't empty
let g:netrw_banner=0                      " Dont show the banner

" Keep the cursor on the same column
set nostartofline


" 80 chars/line
set textwidth=0
if exists('&colorcolumn')
  set colorcolumn=80
endif


" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" set complete=.,w,b,u,t
set complete-=i

" mouse
silent! set ttymouse=xterm2
set mouse=a

" yank to clipboard
if has("clipboard")
  set clipboard=unnamed " copy to the system clipboard

  if has("unnamedplus") " X11 support
    set clipboard+=unnamedplus
  endif
endif
" }}}
" ============================================================================
" MAPPINGS {{{
" ============================================================================

" ----------------------------------------------------------------------------
" Basic mappings
" ----------------------------------------------------------------------------

noremap <C-F> <C-D>
noremap <C-B> <C-U>

" qq to record, Q to replay
nnoremap Q @q

" Disable CTRL-A on tmux or on screen
if $TERM =~ 'screen'
  nnoremap <C-a> <nop>
  nnoremap <Leader><C-a> <C-a>
endif

" Save
inoremap <C-s>     <C-O>:update<cr>
nnoremap <C-s>     :update<cr>
nnoremap <leader>s :update<cr>
nnoremap <leader>w :update<cr>


" Quit
inoremap <C-Q>     <esc>:q<cr>
nnoremap <C-Q>     :q<cr>
vnoremap <C-Q>     <esc>
nnoremap <Leader>q :q<cr>
nnoremap <Leader>Q :qa!<cr>

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright


" Quicker window movement
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Movement in insert mode
inoremap <C-h> <C-o>h
inoremap <C-l> <C-o>a
inoremap <C-j> <C-o>j
inoremap <C-k> <C-o>k
inoremap <C-^> <C-o><C-^>

" Navigating tabs easier
map <D-S-{> :tabprevious
map <D-S-}> :tabprevious

" toggle paste in cmd only
nnoremap <Leader>p :set invpaste<CR>


" ----------------------------------------------------------------------------
" tmux
" ----------------------------------------------------------------------------
function! s:tmux_send(content, dest) range
  let dest = empty(a:dest) ? input('To which pane? ') : a:dest
  let tempfile = tempname()
  call writefile(split(a:content, "\n", 1), tempfile, 'b')
  call system(printf('tmux load-buffer -b vim-tmux %s \; paste-buffer -d -b vim-tmux -t %s',
        \ shellescape(tempfile), shellescape(dest)))
  call delete(tempfile)
endfunction

function! s:tmux_map(key, dest)
  execute printf('nnoremap <silent> %s "tyy:call <SID>tmux_send(@t, "%s")<cr>', a:key, a:dest)
  execute printf('xnoremap <silent> %s "ty:call <SID>tmux_send(@t, "%s")<cr>gv', a:key, a:dest)
endfunction

call s:tmux_map('<leader>tt', '')
call s:tmux_map('<leader>th', '.left')
call s:tmux_map('<leader>tj', '.bottom')
call s:tmux_map('<leader>tk', '.top')
call s:tmux_map('<leader>tl', '.right')
call s:tmux_map('<leader>ty', '.top-left')
call s:tmux_map('<leader>to', '.top-right')
call s:tmux_map('<leader>tn', '.bottom-left')
call s:tmux_map('<leader>t.', '.bottom-right')

" }}}
" ============================================================================
" VIM-PLUG BLOCK {{{
" ============================================================================

call plug#begin('~/.config/nvim/plugged')
" ----------------------------------------------------------------------------
" Colorscheme & Syntax Highlighting
" ----------------------------------------------------------------------------
Plug 'Yggdroot/indentLine',           { 'on': 'IndentLinesEnable' }
autocmd! User indentLine doautocmd indentLine Syntax
Plug 'chriskempson/base16-vim'
Plug 'sheerun/vim-polyglot'

" ----------------------------------------------------------------------------
" Linting
" ----------------------------------------------------------------------------
Plug 'w0rp/ale' 
Plug 'metakirby5/codi.vim'

" ----------------------------------------------------------------------------
" Git
" ----------------------------------------------------------------------------
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'

" ----------------------------------------------------------------------------
" Tmux
" ----------------------------------------------------------------------------
Plug 'christoomey/vim-tmux-navigator'

" ----------------------------------------------------------------------------
" Autocompletion & Snippets
" ----------------------------------------------------------------------------
Plug 'Shougo/deoplete.nvim',         { 'do': ':UpdateRemotePlugins' }
Plug 'honza/vim-snippets' 
Plug 'Shougo/neosnippet-snippets'
Plug 'Shougo/neosnippet'
Plug 'Shougo/neco-vim'
Plug 'zchee/deoplete-zsh'


" ----------------------------------------------------------------------------
" Editing
" ----------------------------------------------------------------------------
Plug 'tpope/vim-surround'
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-endwise'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-commentary',         { 'on': '<Plug>Commentary' }
Plug 'junegunn/vim-easy-align',      { 'on': ['<Plug>(EasyAlign)', 'EasyAlign'] }
Plug 'fatih/vim-hclfmt'
Plug 'plasticboy/vim-markdown'
Plug 'reasonml/vim-reason-loader'
Plug 'tpope/vim-repeat'

" ----------------------------------------------------------------------------
" Javascript
" ----------------------------------------------------------------------------
Plug 'ternjs/tern_for_vim',           { 'for': ['javascript', 'javascript.jsx'] }
Plug 'carlitux/deoplete-ternjs',      { 'for': ['javascript', 'javascript.jsx'], 'do': 'npm install -g tern' }
Plug 'othree/jspc.vim',               { 'for': ['javascript', 'javascript.jsx'] }
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'digitaltoad/vim-pug'
Plug 'prettier/vim-prettier',         {
                                      \ 'do': 'npm install',
                                      \ 'for': ['javascript', 'typescript',
                                      \ 'css', 'less', 'scss', 'json', 'graphql'] }
Plug 'styled-components/vim-styled-components'
autocmd FileType javascript set formatprg=prettier\ --stdin



" ----------------------------------------------------------------------------
" Go
" ----------------------------------------------------------------------------
Plug 'fatih/vim-go',                  {'do': ':GoInstallBinaries' }
"Plug 'zchee/deoplete-go'

" ----------------------------------------------------------------------------
" Searching/Navigation
" ----------------------------------------------------------------------------
Plug 'junegunn/fzf',                  { 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-vinegar'
Plug 'justinmk/vim-dirvish'
Plug 'jremmen/vim-ripgrep'

" ----------------------------------------------------------------------------
" Utils
" ----------------------------------------------------------------------------
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-unimpaired'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'mhinz/vim-startify'
"Plug 'mhinz/vim-grepper'
"Plug 'easymotion/vim-easymotion'
"Plug 'sjl/gundo.vim'
Plug 'jiangmiao/auto-pairs'
"Plug 'rizzatti/dash.vim'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'junegunn/vim-emoji'
Plug 'tpope/vim-sensible'
call plug#end()
" }}}
" ============================================================================
" COLOR SETTINGS {{{
" ============================================================================

" True color
if has('nvim')
  let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
endif

" vim color scheme (base16)
syntax enable

" base16-vim will match whatever you have set your shell color schceme as
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif
" }}}
" ============================================================================
" PLUGIN SETTINGS{{{
" ============================================================================


" ----------------------------------------------------------------------------
" vim-airline (statusbar)
" ----------------------------------------------------------------------------
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='base16'

function ALE() abort
    return exists('*ALEGetStatusLine') ? ALEGetStatusLine() : ''
endfunction
let g:airline_section_error = '%{ALE()}'
let g:ale_statusline_format = ['⨉ %d', '⚠ %d', '⬥ ok']

" ----------------------------------------------------------------------------
" vim-fugitive
" ----------------------------------------------------------------------------
nmap     <Leader>g :Gstatus<CR>gg<c-n>
nnoremap <Leader>d :Gdiff<CR>

" ----------------------------------------------------------------------------
" vim-signify
" ----------------------------------------------------------------------------
let g:signify_vcs_list = ['git']
let g:signify_skip_filetype = { 'journal': 1 }

" ----------------------------------------------------------------------------
" vim-commentary
" ----------------------------------------------------------------------------
map  gc  <Plug>Commentary
nmap gcc <Plug>CommentaryLine


" ----------------------------------------------------------------------------
" ale
" ----------------------------------------------------------------------------
"let g:ale_linters = {'jsx': ['stylelint', 'eslint']}
"let g:ale_linter_aliases = {'jsx': 'css'}


" ----------------------------------------------------------------------------
"Gundu
" ----------------------------------------------------------------------------
"nnoremap <leader>t :GundoToggle<CR>

" ----------------------------------------------------------------------------
" indentLine
" ----------------------------------------------------------------------------
let g:indentLine_enabled = 0

" ----------------------------------------------------------------------------
" Deoplete
" ----------------------------------------------------------------------------
call deoplete#enable()
"let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_ignore_case = 1
let g:neosnippet#enable_snipmate_compatibility = 1

" Javscript Completion
let g:deoplete#sources = {}
let g:deoplete#sources['javascript.jsx'] = ['file', 'neosnippet', 'ternjs']
let g:tern#command = ['tern']
let g:tern#arguments = ['--persistent']

let g:deoplete#omni#functions = {}
let g:deoplete#omni#functions.javascript = [
  \ 'tern#complete',
  \ 'jspc#omni'
\]


" HTML completion
let g:deoplete#sources = {}
let g:deoplete#sources['html'] = ['file', 'neosnippet', 'vim-snippets']



" ----------------------------------------------------------------------------
" Neosnippet controls
" ----------------------------------------------------------------------------


" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
"imap <expr><TAB>
" \ pumvisible() ? "\<C-n>" :
" \ neosnippet#expandable_or_jumpable() ?
" \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif



" I want to use my tab more smarter. If we are inside a completion menu jump
" to the next item. Otherwise check if there is any snippet to expand, if yes
" expand it. Also if inside a snippet and we need to jump tab jumps. If none
" of the above matches we just call our usual 'tab'.
function! s:neosnippet_complete()
  if pumvisible()
    return "\<c-n>"
  else
    if neosnippet#expandable_or_jumpable() 
      return "\<Plug>(neosnippet_expand_or_jump)"
    endif
    return "\<tab>"
  endif
endfunction

imap <expr><TAB> <SID>neosnippet_complete()


" function! s:tab_complete()
"   " is completion menu open? cycle to next item
"   if pumvisible()
"     return "\<c-n>"
"   endif

"   " is there a snippet that can be expanded?
"   " is there a placholder inside the snippet that can be jumped to?
"   if neosnippet#expandable_or_jumpable() 
"     return "\<Plug>(neosnippet_expand_or_jump)"
"   endif

"   " if none of these match just use regular tab
"   return "\<tab>"
" endfunction

" imap <silent><expr><TAB> <SID>tab_complete()

" ----------------------------------------------------------------------------
" vim-signify
" ----------------------------------------------------------------------------
let g:signify_vcs_list = ['git']
let g:signify_skip_filetype = { 'journal': 1 }

" ----------------------------------------------------------------------------
" autopairs
" ----------------------------------------------------------------------------
let g:autopairsmapcr=0 

" ----------------------------------------------------------------------------
" <Enter> | vim-easy-align
" ----------------------------------------------------------------------------
let g:easy_align_delimiters = {
\ '>': { 'pattern': '>>\|=>\|>' },
\ '\': { 'pattern': '\\' },
\ '/': { 'pattern': '//\+\|/\*\|\*/', 'delimiter_align': 'l', 'ignore_groups': ['!Comment'] },
\ ']': {
\     'pattern':       '\]\zs',
\     'left_margin':   0,
\     'right_margin':  1,
\     'stick_to_left': 0
\   },
\ ')': {
\     'pattern':       ')\zs',
\     'left_margin':   0,
\     'right_margin':  1,
\     'stick_to_left': 0
\   },
\ 'f': {
\     'pattern': ' \(\S\+(\)\@=',
\     'left_margin': 0,
\     'right_margin': 0
\   },
\ 'd': {
\     'pattern': ' \ze\S\+\s*[;=]',
\     'left_margin': 0,
\     'right_margin': 0
\   }
\ }

" Start interactive EasyAlign in visual mode
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign with a Vim movement
nmap ga <Plug>(EasyAlign)
nmap gaa ga_

" xmap <Leader><Enter>   <Plug>(LiveEasyAlign)
" nmap <Leader><Leader>a <Plug>(LiveEasyAlign)

" inoremap <silent> => =><Esc>mzvip:EasyAlign/=>/<CR>`z$a<Space>

" ----------------------------------------------------------------------------
" neomake
" ----------------------------------------------------------------------------
"let g:neomake_javascript_enabled_makers = ['eslint']
"let g:neomake_jsx_enabled_makers = ['eslint']
"autocmd! BufWritePost * Neomake
"let g:neomake_verbose=3
"let g:neomake_open_list = 2


" Neomake bindings
"nmap <Leader><Space>o :lopen<CR>      " open location window
"nmap <Leader><Space>c :lclose<CR>     " close location window
"nmap <Leader><Space>, :ll<CR>         " go to current error/warning
"nmap <Leader><Space>n :lnext<CR>      " next error/warning
"nmap <Leader><Space>p :lprev<CR>      " previous error/warning


" }}}
" ============================================================================
" FZF {{{
" ============================================================================

" FZF + Ripgrep

" --column: Show column number
" --line-number: Show line number
" --no-heading: Do not show file headings in results
" --fixed-strings: Search term as a literal string
" --ignore-case: Case insensitive search
" --no-ignore: Do not respect .gitignore, etc...
" --hidden: Search hidden files and folders
" --follow: Follow symlinks
" --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
" --color: Search color options
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)

nmap <C-p> :Files<cr>
  imap <c-x><c-l> <plug>(fzf-complete-line)

  let g:fzf_action = {
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-i': 'split',
    \ 'ctrl-s': 'vsplit' }
  let g:fzf_layout = { 'down': '~20%' }

  let g:rg_command = '
    \ rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --color "always"
    \ -g "*.{js,json,php,md,styl,pug,jade,html,config,py,cpp,c,go,hs,rb,conf,fa,lst}"
    \ -g "!{.config,.git,node_modules,vendor,build,yarn.lock,*.sty,*.bst,*.coffee,dist}/*" '

  command! -bang -nargs=* F call fzf#vim#grep(g:rg_command .shellescape(<q-args>), 1, <bang>0)


nnoremap <silent> <Leader>C        :Colors<CR>
nnoremap <silent> <Leader><Enter>  :Buffers<CR>
nnoremap <silent> <Leader>ag       :Rg <C-R><C-W><CR>
nnoremap <silent> <Leader>AG       :Rg <C-R><C-A><CR>
xnoremap <silent> <Leader>ag       y:Rg <C-R>"<CR>
nnoremap <silent> <Leader>`        :Marks<CR>

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


" }}}
" ============================================================================
" PYENV PATH{{{
" ============================================================================


" Pyenv Paths
" https://github.com/zchee/deoplete-jedi/wiki/Setting-up-Python-for-Neovim#using-virtual-environments
let g:python_host_prog  = '/Users/jon/.pyenv/versions/neovim2/bin/python'
let g:python3_host_prog = '/Users/jon/.pyenv/versions/neovim3/bin/python'


" Faster startup time
  "let g:python_host_skip_check=1            " Skip python 2 host check
  "let g:loaded_python3_provider=1           " Disable python 2 interface

" }}}
" ============================================================================
