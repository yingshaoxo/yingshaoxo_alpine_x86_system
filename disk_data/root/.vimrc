set nocompatible              " be iMproved, required
filetype off                  " required

au FileType c map <F5> :w<CR>:!gcc % && ./a.out %<CR>
au FileType cpp map <F5> :w<CR>:!gcc % && ./a.out %<CR>
au FileType python map <F5> :w<CR>:!python3 %<CR>
au FileType sh map <F5> :w<CR>:!bash %<CR>
syntax on

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set fileformat=unix

set clipboard=unnamedplus

"hide thing on gvim
set guioptions-=m  "menu bar
set guioptions-=T  "toolbar
set guioptions-=r  "scrollbar
set backupcopy=yes

set completeopt-=preview

"no auto indent
filetype indent off
filetype plugin indent off    " required
set noai

let g:vim_json_conceal=0

let g:python_highlight_all = 1

set background=light
