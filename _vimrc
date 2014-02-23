" Environment {
    " Identify platform {
        silent function! OSX()
            return has('macunix')
        endfunction
        silent function! LINUX()
            return has('unix') && !has('macunix') && !has('win32unix')
        endfunction
        silent function! WINDOWS()
            return  (has('win16') || has('win32') || has('win64'))
        endfunction
    " }

    " Basics {
        set nocompatible        " Must be first line
        if has('gui_running')
            language messages en    " Set language and menus to english
        endif
    " }

    " Windows Compatible {
        " On Windows, also use '.vim' and 'vimfiles'; this makes synchronization
        " across (heterogeneous) systems easier.
        " :set path^= adds at the beginning :set path+= adds to the end of the path
        " :echo $VIM
        " $HOME = C:\USERS\PERSEP
        " $VIM = C:\PROGRAM FILES\VIM
        " $VIMRUNTIME = C:\PROGRAM FILES\VIM\VIM74
        if WINDOWS()
              set runtimepath+=$HOME/.vim,$HOME/.vim/after

              " Be nice and check for multi_byte even if the config requires
              " multi_byte support most of the time
              if has("multi_byte")
                " Windows cmd.exe still uses cp850. If Windows ever moved to
                " Powershell as the primary terminal, this would be utf-8
                set termencoding=cp850
                " Let Vim use utf-8 internally, because many scripts require this
                set encoding=utf-8
                setglobal fileencoding=utf-8
                " Windows has traditionally used cp1252, so it's probably wise to
                " fallback into cp1252 instead of eg. iso-8859-15.
                " Newer Windows files might contain utf-8 or utf-16 LE so we might
                " want to try them first.
                set fileencodings=ucs-bom,utf-8,utf-16le,cp1252,iso-8859-15
            endif
        endif
    " }

" }

" Setup Pahogen Support {
    "Installs plugins and runtime files in their own private directories. 
    "https://github.com/tpope/vim-pathogen.git

    execute pathogen#infect()
    "call pathogen#helptags()       "Or use :Helptags command
" }



" General {

    set background=dark         " Assume a dark background
    filetype plugin indent on   " Automatically detect file types.
    syntax on                   " Syntax highlighting
    set mouse=a                 " Automatically enable mouse usage
    set mousehide               " Hide the mouse cursor while typing
    scriptencoding utf-8        " Specify the character encoding used in the script

    if has('clipboard')
        if LINUX()   " On Linux use + register for copy-paste
            set clipboard=unnamedplus       " Uses X windows system clipboard
        else         " On mac and Windows, use * register for copy-paste
            set clipboard=unnamed           " Uses windows system clipboard
        endif
    endif

    "set autowrite                      " Automatically write a file when leaving a modified buffer
    " Dont show the intro message when starting Vim
    set shortmess+=atI                  " Abbrev. of messages (avoids welcome message)
    set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility /\ and eol
    set virtualedit=onemore             " Allow for cursor beyond last character
    set history=1000                    " Store a ton of history (default is 20)
    "set spell                           " Spell checking on
    set hidden                          " Allow buffer switching without saving

    " Setting up the directories {
        set backup                      " Backups are nice ...
        if has('persistent_undo')
            set undofile                " So is persistent undo ...
            set undolevels=1000         " Maximum number of changes that can be undone
            set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
        endif
    " }

" }

" Vim UI {
    " If solarized is installed"
    if filereadable(expand("~/.vim/bundle/vim-colors-solarized/colors/solarized.vim"))
        if has("gui_running")
            call togglebg#map("")
        elseif &term == 'xterm-256color'
                let g:solarized_termcolors = 256
            colo solarized             " Load solarized colorscheme
        endif 
    endif
    
    if &term == 'cygwin'
        colo evening
    endif
    
    if &term == 'xterm'
        colo slate
    endif

    set tabpagemax=15               " Only show 15 tabs
    set showmode                    " Display the current mode

    set cursorline                  " Highlight current line
    
    if &term == 'xterm'
        hi CursorLine term=bold cterm=bold   " Avoid the underline highlight
    endif

    highlight clear SignColumn      " SignColumn should match background
    highlight clear LineNr          " Current line number row will have same background color in relative mode
    "highlight clear CursorLineNr    " Remove highlight color from current line number

    if has('cmdline_info')
        set ruler                   " Show the ruler
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
        set showcmd                 " Show partial commands in status line and
                                    " Selected characters/lines in visual mode
    endif

    if has('statusline')
        set laststatus=2

        " Broken down into easily includeable segments
        set statusline=%<%f\                     " Filename
        set statusline+=%w%h%m%r                 " Options
        set statusline+=%{fugitive#statusline()} " Git Hotness
        set statusline+=\ [%{&ff}/%Y]            " Filetype
        set statusline+=\ [%{getcwd()}]          " Current dir
        set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
    endif

    set backspace=indent,eol,start  " Backspace for dummies
    set linespace=0                 " No extra spaces between rows
    set nu                          " Line numbers on
    set showmatch                   " Show matching brackets/parenthesis
    set incsearch                   " Find as you type search
    set hlsearch                    " Highlight search terms
    "set gdefault                    " Add the g flag to search/replace by default
    set winminheight=0              " Windows can be 0 line high
    set ignorecase                  " Case insensitive search
    set smartcase                   " Case sensitive when uc present
    set wildmenu                    " Show list instead of just completing
    set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
    set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
    set scrolljump=5                " Lines to scroll when cursor leaves screen
    set scrolloff=3                 " Minimum lines to keep above and below cursor
    set foldenable                  " Auto fold code
    set list
    if has('gui_running')           " Highlight problematic whitespace
        " tab: > 1st character occupied by a tab, and - for rest
        " trail: Character to show for trailing spaces.
        " extends: Character to show in the last column, when 'wrap' is off and the line continues 
        " nbsp:c    Character to show for a non-breakable space
        set listchars=tab:›\ ,trail:•,extends:#,nbsp:. 
    else
        set listchars=tab:>\ ,trail:·,extends:#,nbsp:. " Highlight problematic whitespace
    endif
    set vb t_vb=                        "Use visual bell w no flash instead of beeping.
    autocmd GUIEnter * set vb t_vb=     " Disable flash in gui mode. Execute command on event GUIEnter on ALL Files

" }

" Formatting {

    set wrap                      " Do not wrap long lines
    set autoindent                  " Indent at the same level of the previous line
    set shiftwidth=4                " Use indents of 4 spaces
    set expandtab                   " Tabs are spaces, not tabs
                                    " Explanations from http://tedlogan.com/techblog3.html
    set tabstop=4                   " An indentation every four columns
    set softtabstop=4               " Let backspace delete indent
    set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
    set splitright                  " Puts new vsplit windows to the right of the current
    set splitbelow                  " Puts new split windows to the bottom of the current
    "set matchpairs+=<:>            " Match, to be used with %
    set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)
    "set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks
    
    " Remove trailing whitespaces and ^M chars
    autocmd FileType c,cpp,java,go,php,javascript,python,twig,xml,yml autocmd BufWritePre <buffer> call StripTrailingWhitespace()
    autocmd FileType go autocmd BufWritePre <buffer> Fmt
    autocmd BufNewFile,BufRead *.html.twig set filetype=html.twig
    autocmd FileType haskell setlocal expandtab shiftwidth=2 softtabstop=2
    autocmd BufNewFile,BufRead *.coffee set filetype=coffee

    " Workaround vim-commentary for Haskell
    autocmd FileType haskell setlocal commentstring=--\ %s
    " Workaround broken colour highlighting in Haskell
    autocmd FileType haskell setlocal nospell

    " NICER WORD WRAPPING
    " inspired by http://contsys.tumblr.com/post/491802835/vim-soft-word-wrap
    ":set formatoptions=1
    ":set linebreak
    ":set breakat=\ |@-+;:,./?^I

" }


" Key (re)Mappings {

    " The default leader is '\', but many people prefer ',' as it's in a standard
    " location. 
    
    let mapleader = ','
    let maplocalleader = '_'
    
    " Easier moving in tabs and windows
    " The lines conflict with the default digraph mapping of <C-K>
    
    map <C-J> <C-W>j<C-W>_
    map <C-K> <C-W>k<C-W>_
    map <C-L> <C-W>l<C-W>_
    map <C-H> <C-W>h<C-W>_
    
    " Wrapped lines goes down/up to next row, rather than next line in file.
    noremap j gj
    noremap k gk
    noremap <Down> gj
    noremap <Up> gk
    
    inoremap jk <esc>       " Remapped esc key to jk

    " End/Start of line motion keys act relative to row/wrap width in the
    " presence of `:set wrap`, and relative to line for `:set nowrap`.
    " Default vim behaviour is to act relative to text line in both cases
    
    " Same for 0, home, end, etc
    function! WrapRelativeMotion(key, ...)
        let vis_sel=""
        if a:0
            let vis_sel="gv"
        endif
        if &wrap
            execute "normal!" vis_sel . "g" . a:key
        else
            execute "normal!" vis_sel . a:key
        endif
    endfunction

    " Map g* keys in Normal, Operator-pending, and Visual+select
    noremap $ :call WrapRelativeMotion("$")<CR>
    noremap <End> :call WrapRelativeMotion("$")<CR>
    noremap 0 :call WrapRelativeMotion("0")<CR>
    noremap <Home> :call WrapRelativeMotion("0")<CR>
    noremap ^ :call WrapRelativeMotion("^")<CR>
    " Overwrite the operator pending $/<End> mappings from above
    " to force inclusive motion with :execute normal!
    onoremap $ v:call WrapRelativeMotion("$")<CR>
    onoremap <End> v:call WrapRelativeMotion("$")<CR>
    " Overwrite the Visual+select mode mappings from above
    " to ensure the correct vis_sel flag is passed to function
    vnoremap $ :<C-U>call WrapRelativeMotion("$", 1)<CR>
    vnoremap <End> :<C-U>call WrapRelativeMotion("$", 1)<CR>
    vnoremap 0 :<C-U>call WrapRelativeMotion("0", 1)<CR>
    vnoremap <Home> :<C-U>call WrapRelativeMotion("0", 1)<CR>
    vnoremap ^ :<C-U>call WrapRelativeMotion("^", 1)<CR>
    
    " The following two lines conflict with moving to top and
    " bottom of the screen
    
    map <S-H> gT
    map <S-L> gt
    
    " Stupid shift key fixes
    
    if has("user_commands")
        command! -bang -nargs=* -complete=file E e<bang> <args>
        command! -bang -nargs=* -complete=file W w<bang> <args>
        command! -bang -nargs=* -complete=file Wq wq<bang> <args>
        command! -bang -nargs=* -complete=file WQ wq<bang> <args>
        command! -bang Wa wa<bang>
        command! -bang WA wa<bang>
        command! -bang Q q<bang>
        command! -bang QA qa<bang>
        command! -bang Qa qa<bang>
    endif

    cmap Tabe tabe
    

    " Yank from the cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$

    " Code folding options
    nmap <leader>f0 :set foldlevel=0<CR>
    nmap <leader>f1 :set foldlevel=1<CR>
    nmap <leader>f2 :set foldlevel=2<CR>
    nmap <leader>f3 :set foldlevel=3<CR>
    nmap <leader>f4 :set foldlevel=4<CR>
    nmap <leader>f5 :set foldlevel=5<CR>
    nmap <leader>f6 :set foldlevel=6<CR>
    nmap <leader>f7 :set foldlevel=7<CR>
    nmap <leader>f8 :set foldlevel=8<CR>
    nmap <leader>f9 :set foldlevel=9<CR>

    " Most prefer to toggle search highlighting rather than clear the current
    " search results. 
    " nmap <silent> <leader>/ :nohlsearch<CR>         " To clear search highlighting"

    nmap <silent> <leader>/ :set invhlsearch<CR>    " toggle it on and off

    " Find merge conflict markers
    map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>

    " Shortcuts
    " Change Working Directory to that of the current file
    cmap cwd lcd %:p:h
    cmap cd. lcd %:p:h

    " Visual shifting (does not exit Visual mode)
    vnoremap < <gv
    vnoremap > >gv

    " Allow using the repeat operator with a visual selection (!)
    " http://stackoverflow.com/a/8064607/127816
    vnoremap . :normal .<CR>

    " Fix home and end keybindings for screen, particularly on mac
    " - for some reason this fixes the arrow keys too. huh.
    map [F $
    imap [F $
    map [H g0
    imap [H g0

    " For when you forget to sudo.. Really Write the file.
    cmap w!! w !sudo tee % >/dev/null

    " Some helpers to edit mode
    " http://vimcasts.org/e/14
    cnoremap %% <C-R>=expand('%:h').'/'<cr>
    map <leader>ew :e %%
    map <leader>es :sp %%
    map <leader>ev :vsp %%
    map <leader>et :tabe %%

    " Adjust viewports to the same size
    map <Leader>= <C-w>=

    " Map <Leader>ff to display all lines with keyword under cursor
    " and ask which one to jump to
    nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

    " Easier horizontal scrolling
    map zl zL
    map zh zH

    " FIXME: Revert this f70be548
    " fullscreen mode for GVIM and Terminal, need 'wmctrl' in you PATH
    map <silent> <F11> :call system("wmctrl -ir " . v:windowid . " -b toggle,fullscreen")<CR>

" }

" Plugins {

    " syntastic options {
        
        "syntax checking plugin https://github.com/scrooloose/syntastic.git

        "let g:syntastic_check_on_open=1         " checks when buffers are loaded and on saving"
        "let g:syntastic_loc_list_height=5       " height of the location lists that syntastic opens (10)

        "control what the syntastic statusline text contains
        "%E{...} - hide the text in the brackets unless there are errors
        "%fe - line number of first error
        "%e - number of errors
        "%B{...} - hide the text in the brackets unless there are both warnings AND errors
        "%W{...} - hide the text in the brackets unless there are warnings
        "%fw - line number of first warning
        " %w - number of warnings
        "let g:syntastic_stl_format=' [%E{Err: %fe #%e}%B{, }%W{Warn: %fw #%w}]'

        "let g:syntastic_javascript_checkers = ['jshint']    " Telling which checker to use."

        "Uses the statusline flag formated by syntastic_stl_format
        "set statusline+=%#warningmsg#
        "set statusline+=%{SyntasticStatuslineFlag()}
        "set statusline+=%*

        "The error window will open when errors are detected, and closed when none are detected.
        "let g:syntastic_auto_loc_list=1
    
    " }


    " conque options {

        "terminal emulator which uses a Vim buffer to display the program output
        "http://code.google.com/p/conque/

    " }

" }


" Functions {

    " Initialize directories {
    function! InitializeDirectories()
        let parent = $HOME
        let prefix = 'vim'
        let dir_list = {
                    \ 'backup': 'backupdir',
                    \ 'views': 'viewdir',
                    \ 'swap': 'directory' }

        if has('persistent_undo')
            let dir_list['undo'] = 'undodir'
        endif

        " To specify a directory in which to place the vimbackup,
        " vimviews, vimundo, and vimswap files/directories
    
        let common_dir = parent . '/.' . prefix

        for [dirname, settingname] in items(dir_list)
            let directory = common_dir . dirname . '/'
            if exists("*mkdir")
                if !isdirectory(directory)
                    call mkdir(directory)
                endif
            endif
            if !isdirectory(directory)
                echo "Warning: Unable to create backup directory: " . directory
                echo "Try: mkdir -p " . directory
            else
                let directory = substitute(directory, " ", "\\\\ ", "g")
                exec "set " . settingname . "=" . directory
            endif
        endfor
    endfunction
    call InitializeDirectories()
    " }

    " Strip whitespace {
    function! StripTrailingWhitespace()
        " Preparation: save last search, and cursor position.
        let _s=@/
        let l = line(".")
        let c = col(".")
        " do the business:
        %s/\s\+$//e
        " clean up: restore previous search history, and cursor position
        let @/=_s
        call cursor(l, c)
    endfunction
    " }

    " Shell command {
    function! s:RunShellCommand(cmdline)
        botright new

        setlocal buftype=nofile
        setlocal bufhidden=delete
        setlocal nobuflisted
        setlocal noswapfile
        setlocal nowrap
        setlocal filetype=shell
        setlocal syntax=shell

        call setline(1, a:cmdline)
        call setline(2, substitute(a:cmdline, '.', '=', 'g'))
        execute 'silent $read !' . escape(a:cmdline, '%#')
        setlocal nomodifiable
        1
    endfunction

    command! -complete=file -nargs=+ Shell call s:RunShellCommand(<q-args>)
    " e.g. Grep current file for <search_term>: Shell grep -Hn <search_term> %
    " }

" }

" GUI Settings {

    " GVIM- (here instead of .gvimrc)
    if has('gui_running')
        set guioptions-=T           " Remove the toolbar
        set lines=35                " 35 lines of text instead of 24
        set columns=100             " 100 columns of text
        if LINUX() && has("gui_running")
            set guifont=Andale\ Mono\ Regular\ 16,Menlo\ Regular\ 15,Consolas\ Regular\ 16,Courier\ New\ Regular\ 18
        elseif OSX() && has("gui_running")
            set guifont=Andale\ Mono\ Regular:h16,Menlo\ Regular:h15,Consolas\ Regular:h16,Courier\ New\ Regular:h18
        elseif WINDOWS() && has("gui_running")
            "Inconsolata font http://www.levien.com/type/myfonts/inconsolata.html
            set guifont=Inconsolata:h14,Andale_Mono:h10,Menlo:h10,Consolas:h10,Courier_New:h10
        endif
    endif
" }


