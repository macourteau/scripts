if &t_Co > 1
  syntax on
endif

set autoindent

set tabstop=2
set shiftwidth=2
set expandtab
set hlsearch
set mouse=a

" Highlight characters past column 80.
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.\+/

if &background == "light"
  highlight comment ctermfg=darkgreen guifg=darkgreen
else
  highlight comment ctermfg=green guifg=green
endif

" Disable tab expansion for Makefiles.
au BufNewFile,BufRead Makefile set noet

" Handle tmux $TERM quirks in vim
if $TERM =~ '^screen-256color'
  map <Esc>OH <Home>
  map! <Esc>OH <Home>
  map <Esc>OF <End>
  map! <Esc>OF <End>
endif

" Tab2Space/Space2Tab commands.
:command! -range=% -nargs=0 Tab2Space execute '<line1>,<line2>s#^\t\+#\=repeat(" ", len(submatch(0))*' . &ts . ')'
:command! -range=% -nargs=0 Space2Tab execute '<line1>,<line2>s#^\( \{'.&ts.'\}\)\+#\=repeat("\t", len(submatch(0))/' . &ts . ')'

