set nocompatible
set encoding=utf-8
set hidden
set ts=4
set laststatus=2        " grey status bar at the bottom
syn on                  " syntax highlighting
filetype indent on      " activates indenting for files
set ai                  " auto indenting
set nu                  " line numbers
set ic                  " case insensitive search
set history=1000        " remember more commands and search history
set undolevels=1000     " use many muchos levels of undo

" Use persistent history.
if !isdirectory($HOME . "/.vim/undodir")
    call mkdir($HOME . "/.vim/undodir", "p", 0700)
endif
set undodir=$HOME/.vim/undodir
set undofile

" Find files under etc folder 
set path+=/etc/**

map <f2> :ls<cr>:b<space>
map <f1> :ls<cr>
noremap <C-d> :sh<cr>
nnoremap gr :!go run %<cr>


" :W sudo saves the file 
command W w !sudo tee % > /dev/null

" Colorscheme
colorscheme pablo     
