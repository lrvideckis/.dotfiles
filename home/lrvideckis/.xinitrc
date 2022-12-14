#!/bin/sh

# set wallpaper
nitrogen --restore &

# map caps lock to control
setxkbmap -option caps:ctrl_modifier

# compositor used only for transparent terminal
picom &

qtile start
