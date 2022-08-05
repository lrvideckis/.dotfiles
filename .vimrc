"this is my secret sauce



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
