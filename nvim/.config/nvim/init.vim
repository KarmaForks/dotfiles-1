" vim: set foldmethod=marker foldlevel=0 nomodeline:
" ============================================================================
" Jon Leopard's .vimrc {{{
" ============================================================================

" }}}
" ============================================================================
" BASIC SETTINGS {{{
" ============================================================================
let mapleader = ' '                       " Map  <leader> key to space
let maplocalleader = ' '                  " Map local leader to space
filetype plugin indent on
syntax on
set showmatch           " Show matching bracket.
set number              " Show the line numbers on the left side.
set relativenumber
set lazyredraw          " Don't redraw when there is no need for it
set linebreak           " Wrap lines intelligently, e.g. by end of words
set cursorline          " Spot the cursor easier
set formatoptions+=o    " Continue comment marker in new lines.
set textwidth=80        " Hard-wrap long lines as you type them.
set expandtab           " Insert spaces when TAB is pressed.
set tabstop=2           " Render TABs using this many spaces.
set shiftwidth=2        " Indentation amount for < and > commands.
set noerrorbells        " No beeps.
set nostartofline       " Keep the cursor on the same column
set report=0            " Always report how many lines substitute changed
set list                " Display unusual whitespace characters
set noswapfile          " Don't use swap files, use git
set hidden              " allow buffer switching without saving
set showtabline=2       " always show tabline
set noshowmode          " Don't show current mode in echo
set sidescrolloff=3     " Number of columns to keep on the left/right of the cursor
set title               " Change terminal title based on the file name

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
" nnoremap <Leader>p :set invpaste<CR>

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
Plug 'Yggdroot/indentLine', { 'on': 'IndentLinesEnable' }
autocmd! User indentLine doautocmd indentLine Syntax

Plug 'chriskempson/base16-vim'
Plug 'sheerun/vim-polyglot'
Plug 'hail2u/vim-css3-syntax' " CSS3 syntax (and syntax defined in some foreign specifications) support for Vim's built-in syntax/css.vim
Plug 'ap/vim-css-color'       " Highlight background of CSS colors
Plug 'styled-components/vim-styled-components'
Plug 'jparise/vim-graphql'

" ----------------------------------------------------------------------------
" Linting
" ----------------------------------------------------------------------------
Plug 'w0rp/ale' 

" ----------------------------------------------------------------------------
" Git
" ----------------------------------------------------------------------------
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'airblade/vim-gitgutter'

" ----------------------------------------------------------------------------
" Tmux
" ----------------------------------------------------------------------------
Plug 'christoomey/vim-tmux-navigator'

" ----------------------------------------------------------------------------
" Autocompletion & Snippets
" ----------------------------------------------------------------------------
Plug 'Shougo/deoplete.nvim',         { 'do': ':UpdateRemotePlugins' }
"Plug 'honza/vim-snippets'
Plug 'Shougo/neosnippet-snippets'
Plug 'Shougo/neosnippet'
Plug 'Shougo/neco-vim'

" ----------------------------------------------------------------------------
" Editing
" ----------------------------------------------------------------------------
Plug 'tpope/vim-surround'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-commentary',         { 'on': '<Plug>Commentary' }
Plug 'junegunn/vim-easy-align',      { 'on': ['<Plug>(EasyAlign)', 'EasyAlign'] }
Plug 'plasticboy/vim-markdown'
Plug 'jiangmiao/auto-pairs'     " auto close pairs
Plug 'alvan/vim-closetag'       " html close tags
Plug 'mattn/emmet-vim'          " html expressions

" ----------------------------------------------------------------------------
" Javascript
" ----------------------------------------------------------------------------
Plug 'othree/jspc.vim',               { 'for': ['javascript', 'javascript.jsx'] }
Plug 'digitaltoad/vim-pug'
Plug 'elzr/vim-json'
Plug 'alexlafroscia/deoplete-flow',   { 'branch': 'pass-filename-to-autocomplete' }


" ----------------------------------------------------------------------------
" Go
" ----------------------------------------------------------------------------
Plug 'fatih/vim-go',                  {'do': ':GoInstallBinaries' }

" ----------------------------------------------------------------------------
" Searching/Navigation
" ----------------------------------------------------------------------------
Plug 'junegunn/fzf',                  { 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-vinegar'

" ----------------------------------------------------------------------------
" Utils
" ----------------------------------------------------------------------------
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-obsession'
Plug 'itchyny/lightline.vim'
Plug 'daviesjamie/vim-base16-lightline'
Plug 'maximbaz/lightline-ale'
Plug 'maximbaz/lightline-trailing-whitespace'
Plug 'mgee/lightline-bufferline'

Plug 'gcavallanti/vim-noscrollbar'
Plug 'mhinz/vim-startify'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'junegunn/vim-emoji'
Plug 'metakirby5/codi.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'editorconfig/editorconfig-vim'
Plug 'ervandew/supertab'



call plug#end()
" }}}
" ============================================================================
" COLOR SETTINGS {{{
" ============================================================================
" True color
if has('nvim')
  let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
endif

" base16-vim will match whatever you have set your shell color scheme as
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif
" }}}
" ============================================================================
" PLUGIN SETTINGS{{{
" ============================================================================


" ----------------------------------------------------------------------------
" startify
" ----------------------------------------------------------------------------

nnoremap <leader>st :Startify<cr>
let g:startify_lists = [
      \ { 'header': ['   MRU'],            'type': 'files' },
      \ { 'header': ['   MRU '. getcwd()], 'type': 'dir' },
      \ { 'header': ['   Sessions'],       'type': 'sessions' },
      \ ]

let g:startify_custom_header       = 'map(startify#fortune#boxed(), "\"   \".v:val")'
let g:startify_fortune_use_unicode = 1
let g:startify_use_env = 1


" ----------------------------------------------------------------------------
" netrw (file explorer)
" ----------------------------------------------------------------------------

" Dont show the banner
let g:netrw_banner=0

" ----------------------------------------------------------------------------
" Lightline (statusbar)
" ----------------------------------------------------------------------------

let g:lightline = {
      \   'colorscheme': 'base16',
      \   'active': {
      \     'left': [ [ 'mode' ], [ 'gitbranch' ], [ 'pwd' ] ],
      \     'right': [ [ 'linter_ok', 'linter_checking', 'linter_errors', 'linter_warnings', 'trailing', 'lineinfo' ], [ 'fileinfo' ], [ 'scrollbar' ] ],
      \   },
      \   'inactive': {
      \     'left': [ [ 'pwd' ], [ 'gitbranch' ] ],
      \     'right': [ [ 'lineinfo' ], [ 'fileinfo' ], [ 'scrollbar' ] ],
      \   },
      \   'tabline': {
      \     'left': [ [ 'buffers' ] ],
      \     'right': [ [ 'close' ] ],
      \   },
      \   'separator': { 'left': '', 'right': '' },
      \   'subseparator': { 'left': '', 'right': '' },
      \   'mode_map': {
      \     'n' : 'N',
      \     'i' : 'I',
      \     'R' : 'R',
      \     'v' : 'V',
      \     'V' : 'V-LINE',
      \     "\<C-v>": 'V-BLOCK',
      \     'c' : 'C',
      \     's' : 'S',
      \     'S' : 'S-LINE',
      \     "\<C-s>": 'S-BLOCK',
      \     't': '󰀣 ',
      \   },
      \   'component': {
      \     'lineinfo': '%l:%-v',
      \   },
      \   'component_expand': {
      \     'buffers': 'lightline#bufferline#buffers',
      \     'trailing': 'lightline#trailing_whitespace#component',
      \     'linter_ok': 'lightline#ale#ok',
      \     'linter_checking': 'lightline#ale#checking',
      \     'linter_warnings': 'lightline#ale#warnings',
      \     'linter_errors': 'lightline#ale#errors',
      \   },
      \   'component_function': {
      \     'pwd': 'LightlineWorkingDirectory',
      \     'scrollbar': 'LightlineScrollbar',
      \     'fileinfo': 'LightlineFileinfo',
      \     'gitbranch': 'fugitive#head',
      \   },
      \   'component_type': {
      \     'buffers': 'tabsel',
      \     'trailing': 'error',
      \     'linter_ok': 'left',
      \     'linter_checking': 'left',
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \   },
      \ }

"Custom components
function! LightlineScrollbar()
  let top_line = str2nr(line('w0'))
  let bottom_line = str2nr(line('w$'))
  let lines_count = str2nr(line('$'))

  if bottom_line - top_line + 1 >= lines_count
    return ''
  endif

  let window_width = winwidth(0)
  if window_width < 90
    let scrollbar_width = 6
  elseif window_width < 120
    let scrollbar_width = 9
  else
    let scrollbar_width = 12
  endif

  return noscrollbar#statusline(scrollbar_width, '-', '#')
endfunction

function! LightlineFileinfo()
  if winwidth(0) < 90
    return ''
  endif

  let encoding = &fenc !=# "" ? &fenc : &enc
  let format = &ff
  let type = &ft !=# "" ? &ft : "no ft"
  return type . ' | ' . format . ' | ' . encoding
endfunction

function! LightlineWorkingDirectory()
  return &ft =~ 'help\|qf' ? '' : fnamemodify(getcwd(), ":~:.")
endfunction


" Nerd Fonts in lightline
let g:lightline#ale#indicator_checking = "\uf110"
let g:lightline#ale#indicator_warnings = "\uf071"
let g:lightline#ale#indicator_errors = "\uf05e"
let g:lightline#ale#indicator_ok = "\uf00c"

" Powerline fonts lightline
"let g:lightline#ale#indicator_warnings = ' '
"let g:lightline#ale#indicator_errors = ' '
"let g:lightline#ale#indicator_checking = ' '

"lightline-bufferline
" Show filename relative to current directory
let g:lightline#bufferline#filename_modifier = ':~:.'
" Use fancy unicode symbols for various indicators
let g:lightline#bufferline#unicode_symbols = 1
" Default pencil is too ugly
"let g:lightline#bufferline#modified = ''
" Default name when no buffer is opened
let g:lightline#bufferline#unnamed = '[No Name]'
 " Don't compress ~/my/folder/name to ~/m/f/n
let g:lightline#bufferline#shorten_path = 0

"Lightline trailing whitespace
let g:lightline#trailing_whitespace#indicator = '•'


" remap arrow keys
nnoremap <Left> :bprev<CR>
nnoremap <Right> :bnext<CR>


" Update and show lightline but only if it's visible (e.g., not in Goyo)
autocmd User ALELint call s:MaybeUpdateLightline()
function! s:MaybeUpdateLightline()
  if exists('#lightline')
    call lightline#update()
  end
endfunction


" ----------------------------------------------------------------------------
" vim-fugitive
" ----------------------------------------------------------------------------
nmap     <Leader>g :Gstatus<CR>gg<c-n>
nnoremap <Leader>d :Gdiff<CR>

" ----------------------------------------------------------------------------
" vim-commentary
" ----------------------------------------------------------------------------
map  gc  <Plug>Commentary
nmap gcc <Plug>CommentaryLine


" ----------------------------------------------------------------------------
" ale
" ----------------------------------------------------------------------------
nmap <leader>p <Plug>(ale_fix)
"let g:ale_echo_msg_format = '%linter% says %s'

let g:ale_linters = {
\   'javascript': ['eslint', 'flow'],
\   'html': ['htmlhint', 'tidy'],
\   'json': ['jsonlint'],
\ }

let g:ale_fixers = {
\   'javascript': ['eslint'],
\   'javascript.jsx': ['eslint']
\ }

let g:ale_completion_enabled = 1
let g:ale_javascript_prettier_use_local_config = 1
"let g:ale_javascript_prettier_use_global = 1
"let g:ale_javascript_eslint_use_global = 1
"let g:ale_javascript_eslint_executable = 'eslint_d'
"let g:ale_javascript_prettier_executable = 'prettier_d'
"let g:ale_javascript_prettier_eslint_options = '--write --single-quote --print-width=80 --parser=flow --tab-width=2'
"autocmd FileType javascript.jsx,javascript setlocal formatprg=prettier\ --stdin
"autocmd FileType javascript set formatprg=prettier-eslint\ --stdin
let g:ale_javascript_prettier_options = '--single-quote --trailing-comma es6'

" ----------------------------------------------------------------------------
" auto-pairs
" ----------------------------------------------------------------------------
"let g:AutoPairsFlyMode = 1
let g:AutoPairsShortcutBackInsert = '<M-b>'

" ----------------------------------------------------------------------------
" Deoplete
" ----------------------------------------------------------------------------
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_ignore_case = 1
let g:deoplete#enable_smart_case  = 1
let g:deoplete#enable_camel_case = 1
filetype plugin on
set omnifunc=syntaxcomplete#Complete
set completeopt=longest,menuone,preview



" " Plugin key-mappings.
" " Note: It must be "imap" and "smap".  It uses <Plug> mappings.
" imap <C-k>     <Plug>(neosnippet_expand_or_jump)
" smap <C-k>     <Plug>(neosnippet_expand_or_jump)
" xmap <C-k>     <Plug>(neosnippet_expand_target)

" tab-complete
"inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

" inoremap <silent><expr><CR> pumvisible() ? deoplete#mappings#close_popup()."\<Plug>(neosnippet_expand_or_jump)" : "\<CR>"


" HTML completion
let g:deoplete#sources = {}
let g:deoplete#sources['html'] = ['file', 'neosnippet', 'vim-snippets']

" Javscript Completion
let g:deoplete#sources = {}
let g:deoplete#sources['javascript.jsx'] = ['file', 'neosnippet']


" Omni
let g:deoplete#omni#functions = {}
let g:deoplete#omni#functions.javascript = [
                \ 'jspc#omni'
                \ ]

" ----------------------------------------------------------------------------
" Neosnippet controls
" ----------------------------------------------------------------------------

"let g:neosnippet#enable_completed_snippet = 1

"" Plugin key-mappings.
"" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

"" SuperTab like snippets behavior.
"" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
"imap <C-k>     <Plug>(neosnippet_expand_or_jump)
""imap <expr><TAB>
"" \ pumvisible() ? "\<C-n>" :
"" \ neosnippet#expandable_or_jumpable() ?
"" \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
"smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
"\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

"" For conceal markers.
"if has('conceal')
"  set conceallevel=2 concealcursor=niv
"endif


"" I want to use my tab more smarter. If we are inside a completion menu jump
"" to the next item. Otherwise check if there is any snippet to expand, if yes
"" expand it. Also if inside a snippet and we need to jump tab jumps. If none
"" of the above matches we just call our usual 'tab'.
"function! s:neosnippet_complete()
"  if pumvisible()
"    return "\<c-n>"
"  else
"    if neosnippet#expandable_or_jumpable() 
"      return "\<Plug>(neosnippet_expand_or_jump)"
"    endif
"    return "\<tab>"
"  endif
"endfunction

"imap <expr><TAB> <SID>neosnippet_complete()

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
" command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)

if has('nvim') || has('gui_running')
  let $FZF_DEFAULT_OPTS .= ' --inline-info'
endif

nmap <C-p> :Files<cr>
  imap <c-x><c-l> <plug>(fzf-complete-line)

  let g:fzf_action = {
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-i': 'split',
    \ 'ctrl-s': 'vsplit' }
  let g:fzf_layout = { 'down': '~20%' }


" In Neovim, you can set up fzf window using a Vim command
let g:fzf_layout = { 'window': 'enew' }
let g:fzf_layout = { 'window': '-tabnew' }
let g:fzf_layout = { 'window': '10split enew' }

" Similarly, we can apply it to fzf#vim#grep. To use ripgrep instead of ag:
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

" Likewise, Files command with preview window
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

let g:rg_command = '
  \ rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --color "always"
  \ -g "*.{js,json,php,md,styl,pug,jade,html,config,py,cpp,c,go,hs,rb,conf,fa,lst}"
  \ -g "!{.config,.git,node_modules,vendor,build,yarn.lock,*.sty,*.bst,*.coffee,dist}/*" '

nnoremap <silent> <expr> <Leader><Leader> (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":Files\<cr>"
nnoremap <silent> <Leader>C        :Colors<CR>
nnoremap <silent> <Leader><Enter>  :Buffers<CR>
nnoremap <silent> <Leader>l        :Lines<CR>
nnoremap <silent> <Leader>ag       :Ag <C-R><C-W><CR>
nnoremap <silent> <Leader>AG       :Ag <C-R><C-A><CR>
xnoremap <silent> <Leader>ag       y:Ag <C-R>"<CR>
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



inoremap <expr> <c-x><c-t> fzf#complete('tmuxwords.rb --all-but-current --scroll 500 --min 5')
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
inoremap <expr> <c-x><c-d> fzf#vim#complete#path('blsd')
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)


command! -bang -nargs=? -complete=dir Files
\ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" Hide statusline of terminal buffer
autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
      \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler


" }}}
" ============================================================================
" Python Location{{{
" ============================================================================

" Python Paths
" https://github.com/zchee/deoplete-jedi/wiki/Setting-up-Python-for-Neovim#using-virtual-environments
let g:python_host_prog  = '/usr/local/bin/python2'
let g:python3_host_prog = '/usr/local/bin/python3'
" }}}
" ============================================================================
