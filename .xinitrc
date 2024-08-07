# map caps lock to control
setxkbmap -option caps:ctrl_modifier

# compositor used only for transparent terminal
picom &

# start qtile :)
qtile start
