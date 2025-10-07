#!/bin/sh
feh --bg-scale ~/Pictures/wallpaper.jpg &
picom -b &
dwmblocks &

xset r rate 200 40 # repeat delay (for backspace & other keys)

# start mpd paused
pgrep -x mpd >/dev/null || { mpd && mpc pause; }

firefox &
st &

# screen saving
xidlehook --not-when-fullscreen --not-when-audio --timer 600 'slock' '' &

exec dwm
