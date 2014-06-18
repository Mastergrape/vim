"" Tims vimrc file.
""
"" Maintainer : Tim Seyschab <tim@technuts.de>
"" Last Modified : Wed Jun 18, 2014  04:42:45 PM
"" Use Vim settings, rather than Vi settings (much better!).
"" This must be first, because it changes other options as a side effect.
set nocompatible

"" Pathogen load plugins
call pathogen#infect()

" ------------------------------------------------------
" 	User Variables (while not frequently changed,
" 	I'd rather let them stay on top)
" ------------------------------------------------------
let s:Author = "MY NAME"

" ------------------------------------------------------
" 	Common Options
" ------------------------------------------------------

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set history=50		" keep 50 lines of command line history
set showcmd		  	" Show incomplete command in status line.
set showmode 	  	" Editmodus-Anzeige in Statuszeile links unten
set report=0 	  	" Hinweis in Statuszeile ab 1 geänderte/gelöschte/eingefügte Zeilen
set autowrite	  	" Automatically save before commands like :next and :make
set hidden        " Hide buffers when they are abandoned
set title			    " File name as window Title "
set icon			    " Dateinamen im Icon anzeigen"
set noerrorbells	" kein Audio-Fehlersound "
set visualbell		" sondern optischer Fehlerhinweis "
set more 			    " use more prompt
set autoread		  " Automatically read a file that has changed on disk "

set number			  "Zeilennummern anzeigen"
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab     "expand tabs to spaces"
set cmdheight=1		"Höhe des Command-Line Bereichs"
set laststatus=2	" Statuszeile in Fenster anzeigen (0=Nie, 1=nur ab 2 Fenstern, 2=immer)

" using c, set a $ sign at the end of the election rather than deleting 
set cpoptions=ces$

set virtualedit=all "can insert anywhere"
set wildmenu        " set wildmenu for better help

" When the page starts to scroll, keep the cursor 8 lines from the top and 8
" lines from the bottom
set scrolloff=8

" --------------------------------------------------------------
"  common mappings
" --------------------------------------------------------------
nmap <silent> <space> za

" do NOT use this fucking buttons
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" and move arround without looking like a moose
let g:hardtime_default_on = 1
let g:hardtime_maxcount = 5

" map F1 to toggle paste because the Help can be quite annoying
set pastetoggle=<F1>

" make movement through windows a bit more natural
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

let mapleader="," " change the mapleader from \ to ,

map Q =}		" Don't use Ex mode, use Q for formatting "

" Swap two words
nmap <silent> gw "_yiw:s/\\(\\%#\\w\\+\\)\\(\\W\\+\\)\\(\\w\\+\\)/\\3\\2\\1/<CR><c-o><c-l>
" --------------------------------------------------------------
"  Mouse support
" --------------------------------------------------------------

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif
set mousehide 		" Hide mouse while typing"

" --------------------------------------------------------------
"  searching
" --------------------------------------------------------------

set hlsearch		" Highlight Search
set incsearch		" Incremental search
set showmatch		" Show matching brackets.
set ignorecase
set smartcase		" Do smart case matching
set wrapscan		" set the search scan to wrap lines

"Use <C-l> to refresh screen and stop search highlight
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>

"map * and # for a better search in visual mode
xnoremap * :<C-u>call <SID>VSetSearch()<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch()<CR>?<C-R>=@/<CR><CR>

function! s:VSetSearch()
  let temp = @s
  norm! gv"sy
  let @/ = '\V' . substitute(escape(@s, '/\'), '\n', '\\n', 'g')
  let @s = temp
endfunction

" --------------------------------------------------------------
"  backup
" --------------------------------------------------------------

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif

set backupdir=~/.vim/backup

" --------------------------------------------------------------
"  Syntax Highlihting
" --------------------------------------------------------------

syntax on			" Syntax Highlighting
" Syntax coloring lines that are too long just slows down the world
set synmaxcol=2048

" --------------------------------------------------------------
"  Printing support
" --------------------------------------------------------------

set printoptions=header:0,duplex:long,paper:letter

" --------------------------------------------------------------
"  Solarized settings
" --------------------------------------------------------------

set t_Co=256
" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
set background=dark
colorscheme solarized

" ------------------------------------------------------
" 	Statusline
" ------------------------------------------------------

set statusline=   " clear the statusline for when vimrc is reloaded
set statusline+=%<%f\ \ \ \                  " file name, truncate
set statusline+=%h%m%r%w                     " flags
set statusline+=[%{strlen(&ft)?&ft:'none'},  " filetype
set statusline+=%{strlen(&fenc)?&fenc:&enc}, " encoding
set statusline+=%{&fileformat}]              " file format
set statusline+=\ %{fugitive#statusline()}
set statusline+=\ Buff:#%-3.3n\                " buffer number
set statusline+=%=                           " right align
set statusline+=%{synIDattr(synID(line('.'),col('.'),1),'name')}\  " highlight
set statusline+=[%b][0x%B]\                   " current char
set statusline+=%-14.(%l,%c%V%)\ %<%P        " offset

" --------------------------------------------------------------
"  Better Folding
" --------------------------------------------------------------

" set foldminlines
let g:foldminlines = 10

function! MyFoldText()
  let line = getline(v:foldstart)
  if match( line, '^[ \t]*\(\/\*\|\/\/\)[*/\\]*[ \t]*$' ) == 0
    let initial = substitute( line, '^\([ \t]\)*\(\/\*\|\/\/\)\(.*\)', '\1\2', '' )
    let linenum = v:foldstart + 1
    while linenum < v:foldend
      let line = getline( linenum )
      let comment_content = substitute( line, '^\([ \t\/\*]*\)\(.*\)$', '\2', 'g' )
      if !empty(comment_content)
        break
      endif
      let linenum = linenum + 1
    endwhile
    let sub = initial . ' ' . comment_content
  else
    let sub = line
    let startbrace = substitute( line, '^.*{[ \t]*$', '{', 'g')
    if startbrace == '{'
      let line = getline(v:foldend)
      let endbrace = substitute( line, '^[ \t]*}\(.*\)$', '}', 'g')
      if endbrace == '}'
        let sub = sub.substitute( line, '^[ \t]*}\(.*\)$', '...}\1', 'g')
      endif
    endif
  endif
  let n = v:foldend - v:foldstart + 1
  let info = " " . n . " lines"
  let nucolwidth = &fdc + &number*&numberwidth
  let winwd = winwidth(0) - nucolwidth - 5
  let fillcharcount = winwd - len(info) - len(sub)
  return sub . repeat(" ",fillcharcount) . info
endfunction

" --------------------------------------------------------------
"  Filetype settings
" --------------------------------------------------------------

filetype on
filetype plugin indent on
au FileType python set foldmethod=indent
au FileType cs set foldmethod=marker | set foldmarker={,} | set foldtext=MyFoldText()
au FileType cpp,c,java set foldmethod=syntax | set foldtext=MyFoldText() | call FoldAllBut(10)

" --------------------------------------------------------------
"  Autocommands
" --------------------------------------------------------------

" Haskell-mode
au BufEnter *.hs compiler ghc
let g:haddock_browser="/usr/bin/links"

" run own intro scripts
autocmd BufNewFile *.c,*.cs,*.cc,*.cpp,*.h,*.java  0r ~/.vim/template/header.cj | call ChangeInfos() | execute "normal G"
autocmd BufNewFile *.py 0r ~/.vim/template/header.py | call ChangeInfos() | execute "normal G"

command! -nargs=* AddHeader call <SID>AddHeader('<args>') 

" Change Last Modified if (and only if) Buffer is modified
autocmd BufWritePre * call LastModified()
autocmd BufWritePre *.c,*.cpp,*.java,*.py,*.js :call <SID>StripWhitesFunction()

"map python interpreter when necessary
autocmd FileType python map <F6> :w<CR>:!python "%"<CR>

"-----------------------------------------------------------------------------
" Fugitive Settings
"-----------------------------------------------------------------------------

nmap <Leader>gs :Gstatus<cr>
nmap <Leader>ge :Gedit<cr>
nmap <Leader>gw :Gwrite<cr>
nmap <Leader>gr :Gread<cr>

"-----------------------------------------------------------------------------
" NERD Tree Plugin Settings
"-----------------------------------------------------------------------------

" Toggle the NERD Tree on an off with F3
nmap <F3> :NERDTreeToggle<CR>

" Show the bookmarks table on startup
let NERDTreeShowBookmarks=1

" Don't display these kinds of files
let NERDTreeIgnore=[ '\.ncb$', '\.suo$', '\.vcproj\.RIMNET', '\.obj$',
                   \ '\.ilk$', '^BuildLog.htm$', '\.pdb$', '\.idb$',
                   \ '\.embed\.manifest$', '\.embed\.manifest.res$',
                   \ '\.intermediate\.manifest$', '^mt.dep$' ]

"-----------------------------------------------------------------------------
" TagBar PLugin Settings
"-----------------------------------------------------------------------------

" Toggle the TagBar on an off with F2
nmap <F2> :TagbarToggle<CR>
" Signatur not really readable in solarized colorscheme
highlight TagbarSignature ctermfg=4 guifg=#0087ff

"-----------------------------------------------------------------------------
" Syntastic PLugin Settings
"-----------------------------------------------------------------------------

let g:syntastic_check_on_open=0
let g:syntastic_enable_signs=1
let g:syntastic_always_populate_loc_list=1
let g:syntastic_auto_loc_list=1

let g:syntastic_cpp_check_header = 1
let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options = '-std=c++1y -stdlib=libc++'

let g:syntastic_mode_map = { 'mode': 'active',
                           \ 'active_filetypes': ['ruby', 'php'],
                           \ 'passive_filetypes': ['puppet','cpp'] }

nmap <F4> :SyntasticCheck<CR>
                                                                    
"-----------------------------------------------------------------------------
" Supertab, neocompletion Plugin Settings
"-----------------------------------------------------------------------------

let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabContextDefaultCompletionType = "<c-n>"
set completeopt=menuone,menu,longest

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif

" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#use_vimproc = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#auto_completion_start_length = 2
let g:neocomplete#enable_prefetch = 1

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vim/dicts/vimshell_hist',
    \ 'scheme' : $HOME.'/.vim/dicts/gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplete#smart_close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction

if !exists('g:neocomplete#force_omni_input_patterns')
let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.c =
      \ '[^.[:digit:] *\t]\%(\.\|->\)\w*'
let g:neocomplete#force_omni_input_patterns.cpp =
      \ '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'

call neocomplete#initialize()

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
 
let g:marching_clang_command = "/usr/bin/clang++"
let g:marching_clang_command_option="-std=c++1y"
let g:marching_include_paths = [  
      \ "/usr/include/c++/4.9.0/x86_64-unknown-linux-gnu/",
      \ "/usr/include/c++/4.9.0/",
      \ "/usr/include/boost/"
      \]

let g:marching_enable_neocomplete = 1
set updatetime=200
"
""let g:neocomplete#force_overwrite_completefunc = 1
let g:necoghc_enable_detailed_browse = 1

"-----------------------------------------------------------------------------
" Unite Settings
"-----------------------------------------------------------------------------

call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])

nnoremap <C-P> :<C-u>Unite  -buffer-name=files   -start-insert buffer file_rec/async:!<cr>
nnoremap <Leader>b :Unite -buffer-name=buffers -quick-match buffer<cr>
nnoremap <Leader>/ :Unite grep:.<cr>

"let g:unite_source_rec_async_command= 'ag --nocolor --nogroup ""'
" Custom mappings for the unite buffer
autocmd FileType unite call s:unite_settings()
function! s:unite_settings()
  " Play nice with supertab
  let b:SuperTabDisabled=1
  " Enable navigation with control-j and control-k in insert mode
  imap <buffer> <C-j>   <Plug>(unite_select_next_line)
  imap <buffer> <BS>  <Left><Del>
endfunction

"-----------------------------------------------------------------------------
" Gundo Setting
"-----------------------------------------------------------------------------

nnoremap <F5> :GundoToggle<CR>

"-----------------------------------------------------------------------------
" LaTex Suite Plugin Settings
"-----------------------------------------------------------------------------

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'

"-----------------------------------------------------------------------------
" VimWiki Settings
"-----------------------------------------------------------------------------

let g:vimwiki_table_mappings = 0
let wiki = {}
let wiki.path = '~/vimwiki/'
let wiki.path_html = '~/.vimwiki_html/'
let wiki.nested_syntaxes = {'python': 'python', 'c++': 'cpp'}
let wiki.template_path = '~/vimwiki/.templates/'
let wiki.template_default = 'def_template'
let g:vimwiki_list = [wiki]

"-----------------------------------------------------------------------------
" Functions
"-----------------------------------------------------------------------------

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis
endif

function! FoldAllBut(foldminlines)
  let save_cursor = getpos(".")
  silent! exe "%foldopen!"
  let l:_none = s:CloseBigFolds([1,0],0,g:foldminlines)
  if (&ft=='java')
    execute "normal ]m"
    exec "foldopen"
  endif
  call setpos('.', save_cursor)
endfunction

function! s:CloseBigFolds(index,level,count)
  let l:codelines = 1
  let l:lnum = a:index[0]
  while l:lnum <= line('$')
    if foldlevel(l:lnum) == a:level
      if l:lnum == line('$')
        if a:level > 0 && l:lnum - a:index[1] > a:count && l:codelines > a:count
          exec a:index[1].",".l:lnum "foldclose"
          exec a:index[1].",".l:lnum "folddoclosed if (foldclosedend('.') - a:index[1]) < a:count | exe 'norm! zo' | endif"
        endif
        return -1
      endif
      let l:codelines += 1
      let l:lnum += 1
      continue
    elseif foldlevel(l:lnum) < a:level                                                                  
      let l:lnum -= 1
      if l:lnum - a:index[1] > a:count && l:codelines > a:count
        exec a:index[1].",".l:lnum "foldclose"
        exec a:index[1].",".l:lnum "folddoclosed if (foldclosedend('.') - (foldclosed('.')+1)) < a:count | exe 'norm! zo' | endif"
      endif
      return l:lnum+1
    elseif foldlevel(l:lnum) > a:level
      let level_new = a:level+1
      let l:ret = s:CloseBigFolds([l:lnum,l:lnum],level_new,a:count)
      if l:ret == -1
        return
      endif
      let l:lnum = l:ret
      let l:codelines += 1
    endif
  endwhile
endfunction

function! <SID>AddHeader(choice)
  let save_cursor = getpos(".")
  let save_cursor[1] = save_cursor[1] + 10 "change 10 to length of header file
  if a:choice == 0
    0r ~/.vim/template/header.cj
  else
    0r ~/.vim/template/header.py
  endif
  call ChangeInfos()
  call histdel('search', -2)
  call setpos('.', save_cursor)
endfunction

function! ChangeInfos()
  let n = min([10, line("$")])
  exe "1," . n . "g/File Name :.*/s//File Name : " .expand("%")
  exe "1," . n . "g/Creation Date :.*/s//Creation Date : " .strftime("%d-%m-%Y")
  exe "1," . n . "g/Created By :.*/s//Created By : " .s:Author
endfunction
 
" Get rid of whitespaces at the end of Lines (gets called on save -- see
" Mapping Section)
function! <SID>StripWhitesFunction()
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  %s/\s\+$//e
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction

function! LastModified()
  if &modified
    let save_cursor = getpos(".")
    let n = min([10, line("$")])
    keepjumps exe '1,' . n . 's#^\(.\{,10}Last Modified :\).*#\1' .
          \ strftime(' %a %b %d, %Y  %X') . '#e'
    call histdel('search', -1)
    call setpos('.', save_cursor)
  endif
endfunction
