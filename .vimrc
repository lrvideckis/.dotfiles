"this is my secret sauce

"general settings
set nocompatible
let indent_len=4 " # of characters which a tab shows up as
let &tabstop=indent_len
let &shiftwidth=indent_len
let &softtabstop=indent_len
set hlsearch ignorecase smartcase incsearch
set showmatch matchpairs+=<:>
set autoindent smartindent cindent
set sidescroll=1 scrolloff=2
set number
set nowrap
set nobackup noswapfile noundofile nowritebackup
syntax on
set listchars=tab:\|\ ,trail:_ list
set wildmenu wildmode=list:longest "bash-like completion
let c_no_curly_error=1 "disable curly brace error: thing[{i, j}]
cal matchadd('ColorColumn', '\%101v.', 100) "101st column limit
colorscheme slate
set cursorline
hi CursorLine cterm=bold,underline

"key maps
inoremap kj <ESC>
inoremap kJ <ESC>
inoremap Kj <ESC>
inoremap KJ <ESC>
cnoremap W w
map Q <NOP>|"disable ex mode
nnoremap <CR> :noh<CR>
inoremap {<CR> {<CR>}<ESC>O
noremap <C-j> 6j
noremap <C-k> 6k
inoremap <tab> <C-n>
inoremap <S-tab> <C-p>
"Catching silly mistakes with GCC: https://codeforces.com/blog/entry/15547
noremap <F5> :w!<CR>:<C-u>!g++ -g -Wall -Wextra -pedantic -Wno-unused-result
\ -DLOCAL -std=c++20 -O2 -Wshadow -Wformat=2 -Wfloat-equal -Wcast-qual
\ -Wcast-align -D_GLIBCXX_DEBUG -D_GLIBCXX_DEBUG_PEDANTIC -fsanitize=address
\ -fsanitize=undefined -fno-sanitize-recover=all -fstack-protector
\ %:r.cpp -o %:r.out<CR>
noremap <F6> :w!<CR>:<C-u>!g++ -std=c++20 %:r.cpp -o %:r.out<CR>
"could add -Wconversion -Wsign-conversion but they cause too many warnings
noremap <F9> :<C-u>!./%:r.out<CR>

"new cpp files default to template
autocmd BufNewFile *.cpp -r ~/programming_team_code/template.cpp

"remove trailing white space during writes
autocmd BufWrite *.cpp,*.h,*.py silent! execute '%s/\s\+$//ge'

"smooth scroll on ctrl-d and ctrl-u
noremap <silent> <c-u> :call SmoothScroll('u', &scroll, 10, 2)<CR>
noremap <silent> <c-d> :call SmoothScroll('d', &scroll, 10, 2)<CR>
function! SmoothScroll(dir, dist, duration, speed)
  for i in range(a:dist/a:speed)
    let start = reltime()
    if a:dir ==# 'd'
      exec "normal! ".a:speed."\<C-e>".a:speed."j"
    else
      exec "normal! ".a:speed."\<C-y>".a:speed."k"
    endif
    redraw
    let elapsed = s:get_ms_since(start)
    let snooze = float2nr(a:duration-elapsed)
    if snooze > 0
      exec "sleep ".snooze."m"
    endif
  endfor
endfunction
function! s:get_ms_since(time)
  let cost = split(reltimestr(reltime(a:time)), '\.')
  return str2nr(cost[0])*1000 + str2nr(cost[1])/1000.0
endfunction
