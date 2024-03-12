# fixes RTE related to `-fsanitize=address`
# https://github.com/google/sanitizers/issues/856#issuecomment-1764667808
sudo sysctl -w kernel.randomize_va_space=0

# need `exec` to logout on command-q instead of just returning to tty
# https://bbs.archlinux.org/viewtopic.php?pid=1491609#p1491609
exec qtile start -b wayland
