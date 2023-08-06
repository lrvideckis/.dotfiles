#!/bin/sh

# map caps lock to control
setxkbmap -option caps:ctrl_modifier

# compositor used only for transparent terminal
picom --fade-in-step=1 --fade-out-step=1 &

qtile start
