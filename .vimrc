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
colorscheme pablo     " colorscheme 

map <f2> :ls<cr>:b<space>
map <f1> :ls<cr>
noremap <C-d> :sh<cr>

set path+=/etc/**
" :W sudo saves the file 
command W w !sudo tee % > /dev/null
map <F2> :ls<CR>:b<Space>
