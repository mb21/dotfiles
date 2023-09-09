set number

"indenting
set autoindent
filetype plugin indent on
set tabstop=2
set shiftwidth=2
set expandtab
set mouse=a

"highlight trailing whitespaces and stuffs
set list
set listchars=tab:>-,trail:·,extends:>,precedes:<,nbsp:.

"select pasted text
nnoremap gp `[v`]

"ccrypt stuff
 au!
 au BufReadPre *.cpt set bin
 au BufReadPre *.cpt set viminfo=
 au BufReadPre *.cpt set noswapfile
 au BufReadPost *.cpt let $vimpass = inputsecret("Password: ")
 au BufReadPost *.cpt silent '[,']!ccrypt -cb -E vimpass
 au BufReadPost *.cpt set nobin
 au BufWritePre *.cpt set bin
 au BufWritePre *.cpt '[,']!ccrypt -e -E vimpass
 au BufWritePost *.cpt u
 au BufWritePost *.cpt set nobin

if has("gui_running")
    set guioptions=egmrt
    set guifont=Monaco:h14

    "when using shift to select words in insert mode, don't include character on the right of cursor
    "deactivated because indenting won't work on mouse selection
    "set selection=exclusive
    "let macvim_hig_shift_movement = 1 "allows highlighting text with shift and arrow-keys

    "when searching: ignore case and start already when typing 
    set ignorecase
    set incsearch
    "set hlsearch

    "use old regexpengine so ruby syntax highlighting isn't painfully slow
    "see http://stackoverflow.com/questions/16902317
    set regexpengine=1
endif

" set every new or read *.md buffer to use the markdown filetype 
autocmd BufRead,BufNewFile *.md set ft=markdown

" don't continue comments on new lines, see :help fo-table
autocmd BufRead,BufNewFile * setlocal formatoptions-=o formatoptions-=r

"open those as zip files
au BufReadCmd *.epub,*.jar,*.docx,*.odt call zip#Browse(expand("<amatch>"))

"collapsable directory listings
"let g:netrw_liststyle=3

"hide
let g:netrw_list_hide= '.DS_Store$,.*\.swp$'

"search recursively in app folder of workingdirectory by default with :find
:set path=**

"tab gives bash-like suggestions on :e
set wildmode=longest,list,full
:set wildmenu

"load bash for :!
:set shell=/bin/bash\ --login\ -i

:set timeout ttimeoutlen=100 "see https://vi.stackexchange.com/questions/15633
let &t_ti.="\<Esc>[1 q"
let &t_SI.="\<Esc>[5 q"
let &t_EI.="\<Esc>[1 q"
let &t_te.="\<Esc>[0 q"
