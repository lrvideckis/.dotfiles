# fixes android studio https://www.reddit.com/r/bspwm/comments/xso4b8/comment/iqlhqvs/
export _JAVA_AWT_WM_NONREPARENTING=1

# need `exec` to logout on command-q instead of just returning to tty
# https://bbs.archlinux.org/viewtopic.php?pid=1491609#p1491609
exec qtile start -b wayland
