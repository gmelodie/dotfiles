#!/bin/sh
feh --bg-scale ~/Pictures/wallpaper.jpg &
picom -b &
dwmblocks &

xset r rate 200 40 # repeat delay (for backspace & other keys)

# screen saving
xidlehook --not-when-fullscreen --not-when-audio --timer 600 'slock' '' &


[ ! -s ~/.config/mpd/pid ] && mpd && mpc pause # start mpd paused

firefox &
st &

exec dwm
